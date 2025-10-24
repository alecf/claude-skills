#!/bin/bash

# Build script for Claude plugins
# Usage: ./scripts/build.sh [plugin-name]
# If no plugin-name provided, builds all plugins

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
PLUGINS_DIR="$REPO_ROOT/plugins"
DIST_DIR="$REPO_ROOT/dist"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Validate plugin directory structure
validate_plugin() {
    local plugin_dir=$1
    local plugin_name=$(basename "$plugin_dir")

    if [ ! -f "$plugin_dir/.claude-plugin/plugin.json" ]; then
        log_error "Missing .claude-plugin/plugin.json in $plugin_name"
        return 1
    fi

    # Validate plugin.json is valid JSON
    if ! jq empty "$plugin_dir/.claude-plugin/plugin.json" 2>/dev/null; then
        log_error "Invalid JSON in $plugin_name/.claude-plugin/plugin.json"
        return 1
    fi

    # Check required fields in plugin.json
    local required_fields=("name" "version" "description")
    for field in "${required_fields[@]}"; do
        if ! jq -e ".$field" "$plugin_dir/.claude-plugin/plugin.json" > /dev/null 2>&1; then
            log_error "Missing required field '$field' in $plugin_name/.claude-plugin/plugin.json"
            return 1
        fi
    done

    return 0
}

# Build a single plugin
build_plugin() {
    local plugin_dir=$1
    local plugin_name=$(basename "$plugin_dir")

    log_info "Building plugin: $plugin_name"

    # Validate plugin structure
    if ! validate_plugin "$plugin_dir"; then
        log_error "Validation failed for $plugin_name"
        return 1
    fi

    # Get version from plugin.json
    local version=$(jq -r '.version' "$plugin_dir/.claude-plugin/plugin.json")

    # Create dist directory for this plugin
    local plugin_dist_dir="$DIST_DIR/$plugin_name"
    mkdir -p "$plugin_dist_dir"

    # Create temporary build directory
    local temp_dir=$(mktemp -d)
    local build_dir="$temp_dir/$plugin_name"
    mkdir -p "$build_dir"

    # Copy entire plugin directory to build directory
    cp -r "$plugin_dir"/* "$build_dir/"
    cp -r "$plugin_dir"/.claude-plugin "$build_dir/"

    # Create zip file
    local zip_file="$plugin_dist_dir/${plugin_name}-v${version}.zip"
    (cd "$temp_dir" && zip -r "$zip_file" "$plugin_name" -q)

    # Create latest symlink/copy
    cp "$zip_file" "$plugin_dist_dir/${plugin_name}-latest.zip"

    # Save version info
    echo "$version" > "$plugin_dist_dir/VERSION"

    # Cleanup
    rm -rf "$temp_dir"

    log_info "Built $plugin_name v$version -> $zip_file"

    return 0
}

# Main
main() {
    log_info "Starting build process..."

    # Ensure dist directory exists
    mkdir -p "$DIST_DIR"

    if [ $# -eq 0 ]; then
        # Build all plugins
        log_info "Building all plugins..."

        local success_count=0
        local fail_count=0

        for plugin_dir in "$PLUGINS_DIR"/*; do
            if [ -d "$plugin_dir" ] && [ "$(basename "$plugin_dir")" != ".*" ]; then
                if build_plugin "$plugin_dir"; then
                    ((success_count++))
                else
                    ((fail_count++))
                fi
            fi
        done

        log_info "Build complete: $success_count succeeded, $fail_count failed"

        if [ $fail_count -gt 0 ]; then
            exit 1
        fi
    else
        # Build specific plugin
        local plugin_name=$1
        local plugin_dir="$PLUGINS_DIR/$plugin_name"

        if [ ! -d "$plugin_dir" ]; then
            log_error "Plugin not found: $plugin_name"
            exit 1
        fi

        if ! build_plugin "$plugin_dir"; then
            exit 1
        fi
    fi

    log_info "All builds successful!"
}

main "$@"
