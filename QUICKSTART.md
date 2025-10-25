# Quick Start Guide

Get started with Claude plugins in 5 minutes.

## For Plugin Users

### Install via Marketplace (Recommended)

**Claude Code only:**

```
/plugin marketplace add alecf/claude-skills
/plugin install blog-profile-analyzer@alecf-claude-skills
```

### Install Manually

**Claude Code:**
```bash
# Download plugin zip
cd ~/.claude/plugins
unzip ~/Downloads/blog-profile-analyzer-plugin-v1.0.0.zip
```

**Claude Desktop (or Claude Code):**
```bash
# Download skill zip
cd ~/.claude/skills
unzip ~/Downloads/blog-profile-analyzer-skill-v1.0.0.zip
```

### Verify Installation

**Via marketplace:**
```
/plugin list
```

**Manual:**
```bash
ls ~/.claude/plugins/  # or ~/.claude/skills/
```

## For Plugin Developers

### 1. Create a New Plugin

```bash
./scripts/new-skill.sh my-plugin
```

### 2. Edit the Files

**plugins/my-plugin/.claude-plugin/plugin.json** - Plugin metadata:
```json
{
  "name": "my-plugin",
  "version": "1.0.0",
  "description": "What this plugin does",
  "author": {
    "name": "Your Name"
  }
}
```

**plugins/my-plugin/skills/my-skill/SKILL.md** - Your skill's prompt:
```markdown
# My Skill

Instructions for Claude to follow when using this skill...
```

### 3. Build and Test

```bash
# Build (creates both plugin and skill zips)
./scripts/build.sh my-plugin

# Test as plugin (Claude Code)
cd ~/.claude/plugins
unzip /path/to/dist/my-plugin/my-plugin-plugin-latest.zip

# Or test as skill (Claude Desktop/Code)
cd ~/.claude/skills
unzip /path/to/dist/my-plugin/my-plugin-skill-latest.zip
```

### 4. Try It

1. Restart Claude Desktop
2. Use your skill
3. Iterate as needed

### 5. Publish It

```bash
# Update version in plugins/my-plugin/.claude-plugin/plugin.json

# Commit and push
git add plugins/my-plugin/
git commit -m "Add my-plugin v1.0.0"
git push
```

GitHub Actions will automatically:
- Build both plugin and skill zips
- Create a release
- Make it available via marketplace and downloads

## Common Commands

```bash
# Create new plugin
./scripts/new-skill.sh plugin-name

# Build plugin (creates both formats)
./scripts/build.sh plugin-name

# Build all plugins
./scripts/build.sh
```

## Directory Structure

```
plugins/my-plugin/
├── .claude-plugin/
│   └── plugin.json           # Plugin metadata (required)
├── skills/
│   └── my-skill/
│       └── SKILL.md          # Skill prompt (required)
└── README.md                 # Documentation (recommended)
```

## File Formats

Each build creates two zips:
- `*-plugin-*.zip` - Full plugin (for Claude Code marketplace)
- `*-skill-*.zip` - Skill only (for Claude Desktop)

## Need Help?

- Read the full [README.md](README.md)
- Check [CONTRIBUTING.md](CONTRIBUTING.md) for details
- Look at existing plugins for examples
- Open an issue with questions

## Pro Tips

1. **Use the marketplace**: Easiest way to install in Claude Code
2. **Test locally first**: Build and install before pushing
3. **Follow semver**: Use proper version numbers (1.0.0, 1.1.0, etc.)
4. **Write good docs**: Include clear usage examples
5. **Both formats**: Each release includes plugin and skill zips

## What's Next?

- Explore existing plugins in `plugins/`
- Read the [CONTRIBUTING.md](CONTRIBUTING.md) guide
- Check out the [README.md](README.md) for installation options
