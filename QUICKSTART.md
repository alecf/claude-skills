# Quick Start Guide

Get started with Claude skills in 5 minutes.

## For Skill Users

### Install a Skill

**Option 1: CLI Installer**
```bash
curl -sSL https://raw.githubusercontent.com/USERNAME/claude-skills/main/scripts/install.sh | bash -s skill-name
```

**Option 2: Manual**
1. Download skill zip from [Releases](../../releases)
2. Extract to `~/.claude/skills/`
3. Restart Claude Desktop

### Verify Installation

```bash
ls ~/.claude/skills/
```

You should see your skill directory there.

## For Skill Developers

### 1. Create a New Skill

```bash
./scripts/new-skill.sh my-skill
```

### 2. Edit the Files

**skills/my-skill/skill.md** - Your skill's prompt:
```markdown
# My Skill

Instructions for Claude to follow when using this skill...
```

**skills/my-skill/manifest.json** - Metadata:
```json
{
  "name": "my-skill",
  "version": "1.0.0",
  "description": "What this skill does"
}
```

### 3. Test It

```bash
# Validate
./scripts/validate.sh my-skill

# Build
./scripts/build.sh my-skill

# Install locally
./scripts/install.sh my-skill
```

### 4. Try It in Claude Desktop

1. Restart Claude Desktop
2. Use your skill
3. Iterate as needed

### 5. Publish It

```bash
# Update version if needed
# Edit skills/my-skill/manifest.json

# Commit and push
git add skills/my-skill/
git commit -m "Add my-skill v1.0.0"
git push
```

GitHub Actions will automatically:
- Validate your skill
- Build the package
- Create a release
- Make it available for installation

## Common Commands

```bash
# Create new skill
./scripts/new-skill.sh skill-name

# Validate skill
./scripts/validate.sh skill-name

# Build skill
./scripts/build.sh skill-name

# Install skill locally
./scripts/install.sh skill-name

# Build all skills
./scripts/build.sh

# Validate all skills
./scripts/validate.sh
```

## Directory Structure

```
skills/my-skill/
├── skill.md        # The skill prompt (required)
├── manifest.json   # Metadata (required)
└── README.md       # Documentation (recommended)
```

## Need Help?

- Read the full [README.md](README.md)
- Check [CONTRIBUTING.md](CONTRIBUTING.md) for details
- Look at existing skills for examples
- Open an issue with questions

## Pro Tips

1. **Use the helper script**: `./scripts/new-skill.sh` creates all files
2. **Validate early**: Run `./scripts/validate.sh` often
3. **Test locally first**: Always test before pushing
4. **Follow semver**: Use proper version numbers (1.0.0, 1.1.0, etc.)
5. **Write good docs**: Future you will thank you

## What's Next?

- Explore existing skills in `skills/`
- Read the [CONTRIBUTING.md](CONTRIBUTING.md) guide
- Check out the [README.md](README.md) for advanced features
