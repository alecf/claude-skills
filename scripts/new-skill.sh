#!/bin/bash

# Helper script to create a new skill from template
# Usage: ./scripts/new-skill.sh skill-name

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SKILLS_DIR="$REPO_ROOT/skills"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

if [ $# -eq 0 ]; then
    log_error "No skill name provided"
    echo ""
    echo "Usage: $0 skill-name"
    echo ""
    echo "Example: $0 my-new-skill"
    exit 1
fi

SKILL_NAME=$1
SKILL_DIR="$SKILLS_DIR/$SKILL_NAME"

# Check if skill already exists
if [ -d "$SKILL_DIR" ]; then
    log_error "Skill '$SKILL_NAME' already exists at $SKILL_DIR"
    exit 1
fi

# Validate skill name format (lowercase, hyphens only)
if ! [[ "$SKILL_NAME" =~ ^[a-z0-9-]+$ ]]; then
    log_error "Invalid skill name. Use lowercase letters, numbers, and hyphens only."
    exit 1
fi

log_info "Creating new skill: $SKILL_NAME"

# Create skill directory
mkdir -p "$SKILL_DIR"

# Create skill.md
cat > "$SKILL_DIR/skill.md" << 'EOF'
# SKILL_NAME_PLACEHOLDER

Your skill instructions go here. This is the main prompt that Claude will use when this skill is invoked.

## What this skill does

Describe what the skill does and when it should be used.

## Instructions

Provide detailed instructions for Claude to follow when executing this skill.
EOF

sed -i '' "s/SKILL_NAME_PLACEHOLDER/$SKILL_NAME/g" "$SKILL_DIR/skill.md" 2>/dev/null || \
    sed -i "s/SKILL_NAME_PLACEHOLDER/$SKILL_NAME/g" "$SKILL_DIR/skill.md"

# Create manifest.json
cat > "$SKILL_DIR/manifest.json" << EOF
{
  "name": "$SKILL_NAME",
  "version": "0.1.0",
  "description": "A brief description of what this skill does",
  "author": "",
  "keywords": []
}
EOF

# Create README.md
cat > "$SKILL_DIR/README.md" << 'EOF'
# SKILL_NAME_PLACEHOLDER

## Description

A brief description of what this skill does.

## Usage

Describe how to use this skill in Claude Code.

## Examples

Provide example usage scenarios.

## Version History

### 0.1.0
- Initial release
EOF

sed -i '' "s/SKILL_NAME_PLACEHOLDER/$SKILL_NAME/g" "$SKILL_DIR/README.md" 2>/dev/null || \
    sed -i "s/SKILL_NAME_PLACEHOLDER/$SKILL_NAME/g" "$SKILL_DIR/README.md"

log_info "Skill created successfully!"
echo ""
echo "Next steps:"
echo "  1. Edit skill.md:      $SKILL_DIR/skill.md"
echo "  2. Update manifest:    $SKILL_DIR/manifest.json"
echo "  3. Update README:      $SKILL_DIR/README.md"
echo "  4. Validate:           ./scripts/validate.sh $SKILL_NAME"
echo "  5. Build:              ./scripts/build.sh $SKILL_NAME"
echo "  6. Test:               ./scripts/install.sh $SKILL_NAME"
echo ""
