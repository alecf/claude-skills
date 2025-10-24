#!/bin/bash

# CLI installer for Claude skills
# Usage:
#   Direct: ./scripts/install.sh skill-name [skill-name2 ...]
#   Remote: curl -sSL https://raw.githubusercontent.com/alecf/claude-skills/main/scripts/install.sh | bash -s skill-name

set -e

# Configuration
REPO_URL="${CLAUDE_SKILLS_REPO:-https://github.com/alecf/claude-skills}"
REPO_RAW_URL="${REPO_URL/github.com/raw.githubusercontent.com}/main"
CLAUDE_SKILLS_DIR="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
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

log_step() {
    echo -e "${BLUE}==>${NC} $1"
}

# Check dependencies
check_dependencies() {
    local missing_deps=()

    if ! command -v curl &> /dev/null; then
        missing_deps+=("curl")
    fi

    if ! command -v unzip &> /dev/null; then
        missing_deps+=("unzip")
    fi

    if ! command -v jq &> /dev/null; then
        missing_deps+=("jq")
    fi

    if [ ${#missing_deps[@]} -gt 0 ]; then
        log_error "Missing required dependencies: ${missing_deps[*]}"
        echo ""
        echo "Please install the missing dependencies:"
        echo "  macOS:   brew install ${missing_deps[*]}"
        echo "  Ubuntu:  sudo apt-get install ${missing_deps[*]}"
        echo "  Fedora:  sudo dnf install ${missing_deps[*]}"
        exit 1
    fi
}

# Detect if running from local repo or remote
is_local_install() {
    [ -f "$(dirname "${BASH_SOURCE[0]}")/../skills/.gitkeep" ]
}

# Install skill from local repository
install_skill_local() {
    local skill_name=$1
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local repo_root="$(cd "$script_dir/.." && pwd)"
    local skill_source="$repo_root/dist/$skill_name"

    log_step "Installing $skill_name from local repository..."

    # Check if skill exists in dist
    if [ ! -d "$skill_source" ]; then
        log_warn "Skill not built yet, building now..."
        "$script_dir/build.sh" "$skill_name"
    fi

    # Find latest zip file
    local zip_file="$skill_source/${skill_name}-latest.zip"

    if [ ! -f "$zip_file" ]; then
        log_error "Build failed or zip file not found for $skill_name"
        return 1
    fi

    # Create skills directory if needed
    mkdir -p "$CLAUDE_SKILLS_DIR"

    # Remove existing skill if present
    if [ -d "$CLAUDE_SKILLS_DIR/$skill_name" ]; then
        log_info "Removing existing version..."
        rm -rf "$CLAUDE_SKILLS_DIR/$skill_name"
    fi

    # Extract skill
    log_info "Extracting skill..."
    unzip -q "$zip_file" -d "$CLAUDE_SKILLS_DIR"

    log_info "Successfully installed $skill_name"
    return 0
}

# Install skill from remote repository
install_skill_remote() {
    local skill_name=$1

    log_step "Installing $skill_name from GitHub releases..."

    # Download the latest zip from GitHub releases
    local download_url="https://github.com/alecf/claude-skills/releases/latest/download/${skill_name}-latest.zip"
    local temp_file=$(mktemp)

    log_info "Downloading from $download_url..."

    if ! curl -fsSL "$download_url" -o "$temp_file"; then
        log_error "Failed to download $skill_name"
        log_error "Make sure the skill exists and has a release"
        rm -f "$temp_file"
        return 1
    fi

    # Create skills directory if needed
    mkdir -p "$CLAUDE_SKILLS_DIR"

    # Remove existing skill if present
    if [ -d "$CLAUDE_SKILLS_DIR/$skill_name" ]; then
        log_info "Removing existing version..."
        rm -rf "$CLAUDE_SKILLS_DIR/$skill_name"
    fi

    # Extract skill
    log_info "Extracting skill..."
    unzip -q "$temp_file" -d "$CLAUDE_SKILLS_DIR"

    # Cleanup
    rm -f "$temp_file"

    log_info "Successfully installed $skill_name"
    return 0
}

# Show installed version
show_version() {
    local skill_name=$1
    local manifest="$CLAUDE_SKILLS_DIR/$skill_name/manifest.json"

    if [ -f "$manifest" ]; then
        local version=$(jq -r '.version' "$manifest" 2>/dev/null || echo "unknown")
        local description=$(jq -r '.description' "$manifest" 2>/dev/null || echo "")
        echo "  Version: $version"
        if [ -n "$description" ]; then
            echo "  Description: $description"
        fi
    fi
}

# Main installation function
install_skill() {
    local skill_name=$1

    if is_local_install; then
        install_skill_local "$skill_name"
    else
        install_skill_remote "$skill_name"
    fi

    local result=$?

    if [ $result -eq 0 ]; then
        show_version "$skill_name"
        echo ""
    fi

    return $result
}

# Main
main() {
    echo ""
    log_info "Claude Skills Installer"
    echo ""

    if [ $# -eq 0 ]; then
        log_error "No skills specified"
        echo ""
        echo "Usage: $0 skill-name [skill-name2 ...]"
        echo ""
        echo "Example:"
        echo "  $0 my-skill"
        echo "  $0 skill1 skill2 skill3"
        echo ""
        exit 1
    fi

    # Check dependencies
    check_dependencies

    # Install each skill
    local success_count=0
    local fail_count=0

    for skill_name in "$@"; do
        if install_skill "$skill_name"; then
            ((success_count++))
        else
            ((fail_count++))
        fi
    done

    # Summary
    echo ""
    log_info "Installation complete: $success_count succeeded, $fail_count failed"

    if [ $success_count -gt 0 ]; then
        echo ""
        log_info "Skills installed to: $CLAUDE_SKILLS_DIR"
        log_info "Restart Claude Desktop to use the new skills"
    fi

    if [ $fail_count -gt 0 ]; then
        exit 1
    fi
}

main "$@"
