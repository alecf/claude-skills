# Claude Skills Marketplace

A curated marketplace of plugins for [Claude Code](https://claude.com/claude-code) to enhance your development workflow.

## Quick Start

Add this marketplace to Claude Code:

```
/plugin marketplace add alecf/claude-skills
```

Then install any plugin:

```
/plugin install blog-profile-analyzer@alecf-claude-skills
```

## Available Plugins

### blog-profile-analyzer

Analyzes blogs and publications to create comprehensive profiles of authors' perspectives, biases, political leanings, and worldviews.

**Use it for:**
- Understanding a blog author's perspective and biases
- Analyzing political leanings of publications
- Comparing perspectives across different blogs
- Critical reading and media literacy

**Install:**
```
/plugin install blog-profile-analyzer@alecf-claude-skills
```

[View Details](plugins/blog-profile-analyzer/README.md) | [Download Latest](https://github.com/alecf/claude-skills/releases/latest/download/blog-profile-analyzer-latest.zip)

## Installation Methods

### Method 1: Via Claude Code Marketplace (Recommended)

This is the easiest way to install plugins directly from Claude Code.

**Step 1: Add the marketplace**
```
/plugin marketplace add alecf/claude-skills
```

**Step 2: Browse and install plugins**

Option A - Interactive:
```
/plugin
```
Then browse the marketplace visually and install plugins.

Option B - Direct install:
```
/plugin install PLUGIN_NAME@alecf-claude-skills
```

### Method 2: Manual Download

If you prefer manual installation:

1. Download the plugin zip from the [Releases](https://github.com/alecf/claude-skills/releases) page
2. Extract to `~/.claude/plugins/`
3. Restart Claude Desktop

**Example:**
```bash
cd ~/.claude/plugins
unzip ~/Downloads/blog-profile-analyzer-v1.0.0.zip
```

### Method 3: Legacy CLI Installer

For backward compatibility with the old skills system:

```bash
curl -sSL https://raw.githubusercontent.com/alecf/claude-skills/main/scripts/install.sh | bash -s PLUGIN_NAME
```

## Using the Plugins

After installation:
1. Restart Claude Desktop (if installed manually)
2. Plugins are automatically available
3. Skills within plugins activate automatically when relevant

## What Are Claude Plugins?

Plugins extend Claude Code with:

- **Skills** - Specialized prompts for specific tasks
- **Commands** - Custom slash commands
- **Agents** - Autonomous task handlers
- **Hooks** - Event-driven automation

This marketplace currently focuses on skills-based plugins, providing Claude with domain expertise for specialized tasks.

## Requirements

- [Claude Desktop](https://claude.com/claude-code) installed
- For manual installation: `unzip` utility
- For CLI installation: `curl`, `unzip`, and `jq`

**Install CLI dependencies:**

**macOS:**
```bash
brew install jq
```

**Ubuntu/Debian:**
```bash
sudo apt-get install jq unzip curl
```

**Fedora:**
```bash
sudo dnf install jq unzip curl
```

## Troubleshooting

### Marketplace Not Found

Make sure you've added the marketplace correctly:
```
/plugin marketplace add alecf/claude-skills
```

You can verify it's added with:
```
/plugin marketplace list
```

### Plugin Not Appearing After Installation

1. Verify installation:
   - Via marketplace: `/plugin list`
   - Manual: `ls ~/.claude/plugins/`
2. Completely restart Claude Desktop (quit and reopen)
3. Try reinstalling via the marketplace

### Installation Failed

1. Check you're using the correct plugin name
2. Verify the marketplace is added: `/plugin marketplace list`
3. Try manual installation instead

## Finding More Plugins

- Browse all plugins in the [plugins/](plugins/) directory
- Check the [Releases](https://github.com/alecf/claude-skills/releases) page for versions
- Use `/plugin` in Claude Code to browse visually

## Contributing Your Own Plugins

Want to create and share your own plugins? See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed instructions on creating, testing, and submitting plugins to this marketplace.

## Team Configuration

Organizations can pre-configure this marketplace for their teams by adding it to `.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": [
    {
      "github": "alecf/claude-skills"
    }
  ]
}
```

When team members trust the folder, Claude Code automatically installs the marketplace.

## Support

- **Issues**: Report problems or request features via [GitHub Issues](https://github.com/alecf/claude-skills/issues)
- **Discussions**: Ask questions or share ideas in [GitHub Discussions](https://github.com/alecf/claude-skills/discussions)
- **Documentation**: [Claude Code Plugin Docs](https://docs.claude.com/en/docs/claude-code/plugins)

## License

Each plugin may have its own license. See individual plugin directories for details.
