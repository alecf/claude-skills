#!/bin/bash

# Validation script for Claude skills
# Usage: ./scripts/validate.sh [skill-name]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SKILLS_DIR="$REPO_ROOT/skills"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

validate_skill() {
    local skill_dir=$1
    local skill_name=$(basename "$skill_dir")
    local errors=0

    log_info "Validating skill: $skill_name"

    # Check for required files
    if [ ! -f "$skill_dir/skill.md" ]; then
        log_error "Missing skill.md"
        ((errors++))
    fi

    if [ ! -f "$skill_dir/manifest.json" ]; then
        log_error "Missing manifest.json"
        ((errors++))
        return $errors
    fi

    # Validate JSON syntax
    if ! jq empty "$skill_dir/manifest.json" 2>/dev/null; then
        log_error "Invalid JSON in manifest.json"
        ((errors++))
        return $errors
    fi

    # Check required manifest fields
    local required_fields=("name" "version" "description")
    for field in "${required_fields[@]}"; do
        if ! jq -e ".$field" "$skill_dir/manifest.json" > /dev/null 2>&1; then
            log_error "Missing required field: $field"
            ((errors++))
        fi
    done

    # Validate version format (semver)
    local version=$(jq -r '.version' "$skill_dir/manifest.json" 2>/dev/null || echo "")
    if [ -n "$version" ]; then
        if ! [[ "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
            log_error "Invalid version format: $version (expected semver: x.y.z)"
            ((errors++))
        fi
    fi

    # Validate name matches directory
    local manifest_name=$(jq -r '.name' "$skill_dir/manifest.json" 2>/dev/null || echo "")
    if [ -n "$manifest_name" ] && [ "$manifest_name" != "$skill_name" ]; then
        log_error "Name mismatch: directory='$skill_name', manifest='$manifest_name'"
        ((errors++))
    fi

    # Check for README
    if [ ! -f "$skill_dir/README.md" ]; then
        log_warn "Missing README.md (recommended)"
    fi

    if [ $errors -eq 0 ]; then
        log_info "$skill_name: PASSED"
    else
        log_error "$skill_name: FAILED with $errors error(s)"
    fi

    return $errors
}

main() {
    local total_errors=0

    if [ $# -eq 0 ]; then
        # Validate all skills
        log_info "Validating all skills..."

        for skill_dir in "$SKILLS_DIR"/*; do
            if [ -d "$skill_dir" ] && [ "$(basename "$skill_dir")" != ".*" ]; then
                if ! validate_skill "$skill_dir"; then
                    ((total_errors++))
                fi
                echo ""
            fi
        done

        if [ $total_errors -eq 0 ]; then
            log_info "All skills validated successfully!"
        else
            log_error "Validation failed for $total_errors skill(s)"
            exit 1
        fi
    else
        # Validate specific skill
        local skill_name=$1
        local skill_dir="$SKILLS_DIR/$skill_name"

        if [ ! -d "$skill_dir" ]; then
            log_error "Skill not found: $skill_name"
            exit 1
        fi

        validate_skill "$skill_dir"
        exit $?
    fi
}

main "$@"
