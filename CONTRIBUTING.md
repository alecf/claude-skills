# Contributing to Claude Skills

Thank you for contributing to this skills repository! This guide will help you add or update skills.

## Repository Overview

This repository provides a structured system for developing, building, and distributing Claude Code skills with:

- **Standardized structure** for skill organization
- **Build tooling** for packaging skills
- **Automated CI/CD** for releases
- **Multiple installation methods** for users

### Repository Structure

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
│   ├── validate.sh           # Validate skill structure
│   └── new-skill.sh          # Create skill template
├── .github/workflows/   # CI/CD automation
│   ├── validate.yml          # Validate on PRs
│   └── release.yml           # Auto-release on changes
├── README.md            # User-facing documentation
├── CONTRIBUTING.md      # This file
└── QUICKSTART.md        # Quick reference guide
```

## Quick Start

### Creating a New Skill

```bash
# Use the helper script
./scripts/new-skill.sh my-skill-name

# Or create manually
mkdir -p skills/my-skill-name
# Then create skill.md, manifest.json, and README.md
```

### Skill Structure

Each skill must have:
```
skills/my-skill-name/
├── skill.md          # Required: The skill prompt
├── manifest.json     # Required: Metadata and version
└── README.md         # Recommended: Documentation
```

## File Templates

### skill.md

```markdown
# Skill Name

Clear description of what this skill does.

## When to Use

Explain when Claude should use this skill.

## Instructions

1. Detailed step-by-step instructions
2. What Claude should do
3. Expected outputs or results
```

### manifest.json

```json
{
  "name": "my-skill-name",
  "version": "1.0.0",
  "description": "Brief one-line description",
  "author": "Your Name",
  "keywords": ["relevant", "tags"]
}
```

**Important Rules:**
- `name` must match the directory name exactly
- `version` must follow semantic versioning (X.Y.Z)
- `description` should be concise (under 100 characters)

### README.md

```markdown
# Skill Name

## Description
What does this skill do?

## Usage
How should users invoke or use this skill?

## Examples
Concrete examples of the skill in action.

## Version History
### 1.0.0
- Initial release
```

## Validation

Before committing, validate your skill:

```bash
# Validate structure and syntax
./scripts/validate.sh my-skill-name

# Build to test packaging
./scripts/build.sh my-skill-name

# Install locally to test
./scripts/install.sh my-skill-name
```

## Testing

1. **Local Testing**: Install the skill in Claude Desktop
   ```bash
   ./scripts/install.sh my-skill-name
   ```

2. **Restart Claude Desktop**: Required for skills to load

3. **Test the skill**: Verify it works as expected

4. **Check error handling**: Test edge cases

## Versioning

Follow [Semantic Versioning](https://semver.org/):

- **MAJOR** (X.0.0): Breaking changes or major rewrites
  - Changes that require users to modify their usage
  - Incompatible with previous versions

- **MINOR** (0.X.0): New features (backward compatible)
  - Adding new functionality
  - Enhancements that don't break existing usage

- **PATCH** (0.0.X): Bug fixes
  - Fixing errors or typos
  - Performance improvements
  - Documentation updates

### Version Update Checklist

- [ ] Update `version` in manifest.json
- [ ] Add version entry to README.md
- [ ] Describe changes in commit message
- [ ] Test the updated skill locally

## Pull Request Process

1. **Create a branch**
   ```bash
   git checkout -b add-my-skill
   ```

2. **Add your skill**
   ```bash
   ./scripts/new-skill.sh my-skill
   # Edit the files
   ```

3. **Validate**
   ```bash
   ./scripts/validate.sh my-skill
   ./scripts/build.sh my-skill
   ```

4. **Commit**
   ```bash
   git add skills/my-skill/
   git commit -m "Add my-skill v1.0.0"
   ```

5. **Push and create PR**
   ```bash
   git push origin add-my-skill
   # Create PR on GitHub
   ```

6. **Wait for CI**: GitHub Actions will validate your skill

7. **Merge**: Once approved, merge to main

8. **Automatic Release**: GitHub Actions will create a release

## Updating Existing Skills

1. **Make your changes** in `skills/skill-name/`

2. **Update version** in manifest.json
   ```json
   {
     "version": "1.1.0"
   }
   ```

3. **Update README.md** with version notes
   ```markdown
   ### 1.1.0
   - Added new feature X
   - Fixed issue Y
   ```

4. **Validate and test**
   ```bash
   ./scripts/validate.sh skill-name
   ./scripts/build.sh skill-name
   ./scripts/install.sh skill-name
   ```

5. **Commit with descriptive message**
   ```bash
   git commit -m "Update skill-name to v1.1.0: Add feature X"
   ```

## Skill Writing Best Practices

### Clear Instructions
- Use clear, imperative language
- Break down complex tasks into steps
- Specify expected inputs and outputs

### Scope Definition
- Define when the skill should be used
- Explain what it does and doesn't do
- Set clear boundaries

### Examples in Documentation
- Provide concrete usage examples
- Show input/output samples
- Cover common use cases

### Error Handling
- Describe how to handle edge cases
- Specify what to do when things go wrong
- Include validation steps

### Keywords
- Add relevant keywords to manifest.json
- Help users discover your skill
- Use common terminology

## Build Scripts Reference

### validate.sh

Validates skill structure and manifest:

```bash
# Validate all skills
./scripts/validate.sh

# Validate specific skill
./scripts/validate.sh my-skill
```

**Checks:**
- Required files exist (skill.md, manifest.json)
- Valid JSON syntax
- Required manifest fields present
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

**Creates:**
- `dist/skill-name/skill-name-vX.Y.Z.zip` (versioned)
- `dist/skill-name/skill-name-latest.zip` (for latest release)
- `dist/skill-name/VERSION` (version tracking)

**Note:** The `dist/` directory is gitignored. Built files are distributed via GitHub Releases.

### install.sh

Installs skills to Claude Desktop:

```bash
# Install one skill locally
./scripts/install.sh my-skill

# Install multiple skills
./scripts/install.sh skill1 skill2 skill3

# Custom installation directory
CLAUDE_SKILLS_DIR=/custom/path ./scripts/install.sh my-skill
```

For local development, this installs from the `dist/` directory. For remote users, it downloads from GitHub Releases.

### new-skill.sh

Creates a new skill from template:

```bash
./scripts/new-skill.sh my-new-skill
```

Creates all required files with templates and placeholders.

## CI/CD Pipeline

### Validation Workflow (`.github/workflows/validate.yml`)

**Triggers:** Pull requests and pushes to main affecting `skills/`

**Actions:**
1. Validates all changed skills
2. Builds skills to verify packaging
3. Uploads build artifacts for PR review

### Release Workflow (`.github/workflows/release.yml`)

**Triggers:** Pushes to main affecting `skills/`

**Actions:**
1. Detects which skills were modified
2. Validates and builds changed skills
3. Creates GitHub releases with version tags (`skill-name-vX.Y.Z`)
4. Attaches zip files to releases
5. Makes skills available for installation

**Important:** The dist/ folder is never committed. All distribution happens through GitHub Releases.

## Common Validation Errors

### "Missing skill.md"
- Ensure `skill.md` exists in the skill directory
- Check file name spelling (lowercase)

### "Invalid JSON in manifest.json"
- Validate JSON syntax with `jq . skills/my-skill/manifest.json`
- Check for trailing commas
- Ensure proper quote matching

### "Invalid version format"
- Use semantic versioning: `1.0.0`
- No prefix (no "v1.0.0")
- Three numbers separated by periods

### "Name mismatch"
- Directory name must match `name` field in manifest.json
- Both should use lowercase and hyphens

## Getting Help

- Check existing skills for examples
- Review the main README.md
- Open an issue for questions
- Ask in discussions

## Code of Conduct

- Be respectful and constructive
- Help others learn and improve
- Focus on skill quality and usefulness
- Welcome feedback graciously
