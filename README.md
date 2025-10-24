# Claude Skills Repository

A structured repository for developing, building, and distributing Claude Code skills.

## Overview

This repository provides:
- Standardized structure for Claude skills
- Build tooling for packaging skills
- Multiple installation methods
- Automated CI/CD for releases

## Repository Structure

```
claude-skills/
├── skills/              # Individual skill directories
│   └── skill-name/
│       ├── skill.md           # Main skill prompt
│       ├── manifest.json      # Metadata and versioning
│       └── README.md          # Skill documentation
├── scripts/             # Build and installation tools
│   ├── build.sh              # Package skills into zips
│   ├── install.sh            # CLI installer
│   └── validate.sh           # Validate skill structure
├── .github/workflows/   # CI/CD automation
└── dist/                # Built packages (auto-generated)
```

## Creating a New Skill

### 1. Create Skill Directory

```bash
mkdir -p skills/my-skill
```

### 2. Create skill.md

Create `skills/my-skill/skill.md` with your skill's prompt:

```markdown
# My Skill

Your skill instructions go here...
```

### 3. Create manifest.json

Create `skills/my-skill/manifest.json`:

```json
{
  "name": "my-skill",
  "version": "1.0.0",
  "description": "A brief description of what this skill does",
  "author": "Your Name",
  "keywords": ["keyword1", "keyword2"]
}
```

**Important**: The `name` field must match the directory name.

### 4. Create README.md (Optional but Recommended)

Create `skills/my-skill/README.md` to document your skill:

```markdown
# My Skill

## Description
What does this skill do?

## Usage
How to use this skill...

## Examples
Example usage...
```

### 5. Validate Your Skill

```bash
./scripts/validate.sh my-skill
```

### 6. Build Your Skill

```bash
./scripts/build.sh my-skill
```

This creates:
- `dist/my-skill/my-skill-v1.0.0.zip`
- `dist/my-skill/my-skill-latest.zip`

## Installing Skills

### Method 1: CLI Installer (Recommended)

**Local installation** (from this repository):
```bash
./scripts/install.sh my-skill
```

**Remote installation** (from GitHub):
```bash
curl -sSL https://raw.githubusercontent.com/USERNAME/claude-skills/main/scripts/install.sh | bash -s my-skill
```

Install multiple skills at once:
```bash
./scripts/install.sh skill1 skill2 skill3
```

### Method 2: Manual Download

1. Download the skill zip from GitHub Releases
2. Extract the contents to `~/.claude/skills/`
3. Restart Claude Desktop

Example:
```bash
cd ~/.claude/skills
unzip ~/Downloads/my-skill-v1.0.0.zip
```

## Updating a Skill

### 1. Make Your Changes

Edit the skill files in `skills/my-skill/`

### 2. Update Version

Update the version in `skills/my-skill/manifest.json`:

```json
{
  "version": "1.1.0"
}
```

Follow [Semantic Versioning](https://semver.org/):
- `MAJOR.MINOR.PATCH`
- MAJOR: Breaking changes
- MINOR: New features (backward compatible)
- PATCH: Bug fixes

### 3. Commit and Push

```bash
git add skills/my-skill/
git commit -m "Update my-skill to v1.1.0"
git push
```

### 4. Automated Release

When you push to `main`, GitHub Actions will:
- Detect which skills changed
- Validate the changes
- Build the updated skills
- Create a GitHub release with the new version
- Commit the built packages to the `dist/` directory

## Development Workflow

### Local Development

1. Create or modify skills in `skills/`
2. Validate: `./scripts/validate.sh skill-name`
3. Build: `./scripts/build.sh skill-name`
4. Test locally: `./scripts/install.sh skill-name`
5. Test in Claude Desktop

### Publishing

1. Update version in `manifest.json`
2. Commit and push to `main`
3. GitHub Actions automatically builds and releases

## Build Scripts Reference

### validate.sh

Validates skill structure and manifest:

```bash
# Validate all skills
./scripts/validate.sh

# Validate specific skill
./scripts/validate.sh my-skill
```

Checks:
- Required files exist (skill.md, manifest.json)
- Valid JSON syntax
- Required manifest fields
- Version format (semver)
- Name matches directory

### build.sh

Packages skills into installable zips:

```bash
# Build all skills
./scripts/build.sh

# Build specific skill
./scripts/build.sh my-skill
```

Creates:
- `dist/skill-name/skill-name-vX.Y.Z.zip`
- `dist/skill-name/skill-name-latest.zip`
- `dist/skill-name/VERSION`

### install.sh

Installs skills to Claude Desktop:

```bash
# Install one skill
./scripts/install.sh my-skill

# Install multiple skills
./scripts/install.sh skill1 skill2 skill3

# Custom installation directory
CLAUDE_SKILLS_DIR=/custom/path ./scripts/install.sh my-skill
```

## CI/CD Pipeline

### Validation Workflow

Runs on PRs and pushes to `main`:
- Validates all changed skills
- Builds skills to verify they package correctly
- Uploads build artifacts for PR review

### Release Workflow

Runs on pushes to `main`:
- Detects which skills were modified
- Validates and builds changed skills
- Creates GitHub releases with version tags
- Attaches zip files to releases
- Commits built packages to repository

## Requirements

### For Development

- bash
- jq (JSON processor)
- zip/unzip

**Install on macOS:**
```bash
brew install jq
```

**Install on Ubuntu/Debian:**
```bash
sudo apt-get install jq zip unzip
```

### For CI/CD

- GitHub repository with Actions enabled
- No additional setup required (runs on Ubuntu)

## Configuration

### Environment Variables

- `CLAUDE_SKILLS_DIR`: Installation directory (default: `~/.claude/skills`)
- `CLAUDE_SKILLS_REPO`: Repository URL for remote installation

### Repository Setup

After creating skills, update `scripts/install.sh` line 8:
```bash
REPO_URL="${CLAUDE_SKILLS_REPO:-https://github.com/YOUR_USERNAME/claude-skills}"
```

## manifest.json Schema

```json
{
  "name": "skill-name",           // Required: Must match directory name
  "version": "1.0.0",             // Required: Semver format
  "description": "...",           // Required: Brief description
  "author": "Your Name",          // Optional: Author name
  "license": "MIT",               // Optional: License
  "homepage": "https://...",      // Optional: Homepage URL
  "repository": "https://...",    // Optional: Source repository
  "keywords": ["tag1", "tag2"],   // Optional: Search keywords
  "dependencies": []              // Optional: Future use
}
```

## Troubleshooting

### Skill Not Found After Installation

1. Check installation directory: `ls ~/.claude/skills/`
2. Verify skill was extracted: `ls ~/.claude/skills/my-skill/`
3. Restart Claude Desktop completely

### Build Fails

1. Run validation: `./scripts/validate.sh my-skill`
2. Check manifest.json is valid JSON: `jq . skills/my-skill/manifest.json`
3. Ensure version follows semver format: `X.Y.Z`

### GitHub Actions Not Running

1. Check Actions are enabled in repository settings
2. Verify workflow files are in `.github/workflows/`
3. Ensure changes are pushed to `main` branch
4. Check workflow logs in Actions tab

## Examples

See the `skills/` directory for example skills (once you add them).

## Contributing

When adding skills to this repository:

1. Follow the skill structure guidelines
2. Validate before committing
3. Use semantic versioning
4. Include a README.md with examples
5. Test installation locally

## License

Specify your repository license here.
