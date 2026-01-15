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

    # ===== Build 1: Full Plugin Zip (for Claude Code marketplace) =====
    local plugin_build_dir="$temp_dir/plugin/$plugin_name"
    mkdir -p "$plugin_build_dir"

    # Copy entire plugin directory
    cp -r "$plugin_dir"/* "$plugin_build_dir/"
    cp -r "$plugin_dir"/.claude-plugin "$plugin_build_dir/"

    # Create plugin zip file
    local plugin_zip="$plugin_dist_dir/${plugin_name}-plugin-v${version}.zip"
    (cd "$temp_dir/plugin" && zip -r "$plugin_zip" "$plugin_name" -q)
    cp "$plugin_zip" "$plugin_dist_dir/${plugin_name}-plugin-latest.zip"

    log_info "Built plugin zip: ${plugin_name}-plugin-v${version}.zip"

    # ===== Build 2: Skill-only Zips (for Claude Desktop & manual installation) =====
    # Check if plugin contains skills
    if [ -d "$plugin_dir/skills" ]; then
        for skill_dir in "$plugin_dir/skills"/*; do
            if [ -d "$skill_dir" ]; then
                local skill_name=$(basename "$skill_dir")
                local skill_build_dir="$temp_dir/skills/$skill_name"
                mkdir -p "$skill_build_dir"

                # Copy only the SKILL.md file
                if [ -f "$skill_dir/SKILL.md" ]; then
                    cp "$skill_dir/SKILL.md" "$skill_build_dir/"

                    # Create skill zip file
                    local skill_zip="$plugin_dist_dir/${skill_name}-skill-v${version}.zip"
                    (cd "$temp_dir/skills" && zip -r "$skill_zip" "$skill_name" -q)
                    cp "$skill_zip" "$plugin_dist_dir/${skill_name}-skill-latest.zip"

                    log_info "Built skill zip: ${skill_name}-skill-v${version}.zip"
                fi
            fi
        done
    fi

    # Save version info
    echo "$version" > "$plugin_dist_dir/VERSION"

    # Cleanup
    rm -rf "$temp_dir"

    log_info "Build complete for $plugin_name v$version"

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
                    ((success_count++)) || true
                else
                    ((fail_count++)) || true
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
