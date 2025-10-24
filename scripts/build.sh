#!/bin/bash

# Build script for Claude skills
# Usage: ./scripts/build.sh [skill-name]
# If no skill-name provided, builds all skills

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SKILLS_DIR="$REPO_ROOT/skills"
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

# Validate skill directory structure
validate_skill() {
    local skill_dir=$1
    local skill_name=$(basename "$skill_dir")

    if [ ! -f "$skill_dir/skill.md" ]; then
        log_error "Missing skill.md in $skill_name"
        return 1
    fi

    if [ ! -f "$skill_dir/manifest.json" ]; then
        log_error "Missing manifest.json in $skill_name"
        return 1
    fi

    # Validate manifest.json is valid JSON
    if ! jq empty "$skill_dir/manifest.json" 2>/dev/null; then
        log_error "Invalid JSON in $skill_name/manifest.json"
        return 1
    fi

    # Check required fields in manifest
    local required_fields=("name" "version" "description")
    for field in "${required_fields[@]}"; do
        if ! jq -e ".$field" "$skill_dir/manifest.json" > /dev/null 2>&1; then
            log_error "Missing required field '$field' in $skill_name/manifest.json"
            return 1
        fi
    done

    return 0
}

# Build a single skill
build_skill() {
    local skill_dir=$1
    local skill_name=$(basename "$skill_dir")

    log_info "Building skill: $skill_name"

    # Validate skill structure
    if ! validate_skill "$skill_dir"; then
        log_error "Validation failed for $skill_name"
        return 1
    fi

    # Get version from manifest
    local version=$(jq -r '.version' "$skill_dir/manifest.json")

    # Create dist directory for this skill
    local skill_dist_dir="$DIST_DIR/$skill_name"
    mkdir -p "$skill_dist_dir"

    # Create temporary build directory
    local temp_dir=$(mktemp -d)
    local build_dir="$temp_dir/$skill_name"
    mkdir -p "$build_dir"

    # Copy skill files to build directory
    cp "$skill_dir/skill.md" "$build_dir/"
    cp "$skill_dir/manifest.json" "$build_dir/"

    if [ -f "$skill_dir/README.md" ]; then
        cp "$skill_dir/README.md" "$build_dir/"
    fi

    # Copy any additional files (images, etc.)
    if [ -d "$skill_dir/assets" ]; then
        cp -r "$skill_dir/assets" "$build_dir/"
    fi

    # Create zip file
    local zip_file="$skill_dist_dir/${skill_name}-v${version}.zip"
    (cd "$temp_dir" && zip -r "$zip_file" "$skill_name" -q)

    # Create latest symlink/copy
    cp "$zip_file" "$skill_dist_dir/${skill_name}-latest.zip"

    # Save version info
    echo "$version" > "$skill_dist_dir/VERSION"

    # Cleanup
    rm -rf "$temp_dir"

    log_info "Built $skill_name v$version -> $zip_file"

    return 0
}

# Main
main() {
    log_info "Starting build process..."

    # Ensure dist directory exists
    mkdir -p "$DIST_DIR"

    if [ $# -eq 0 ]; then
        # Build all skills
        log_info "Building all skills..."

        local success_count=0
        local fail_count=0

        for skill_dir in "$SKILLS_DIR"/*; do
            if [ -d "$skill_dir" ] && [ "$(basename "$skill_dir")" != ".*" ]; then
                if build_skill "$skill_dir"; then
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
        # Build specific skill
        local skill_name=$1
        local skill_dir="$SKILLS_DIR/$skill_name"

        if [ ! -d "$skill_dir" ]; then
            log_error "Skill not found: $skill_name"
            exit 1
        fi

        if ! build_skill "$skill_dir"; then
            exit 1
        fi
    fi

    log_info "All builds successful!"
}

main "$@"
