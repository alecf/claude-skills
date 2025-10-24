# Claude Skills

A collection of skills for [Claude Code](https://claude.com/claude-code) to enhance your development workflow.

## Available Skills

### blog-profile-analyzer

Analyzes blogs and publications to create comprehensive profiles of authors' perspectives, biases, political leanings, and worldviews.

**Use it for:**
- Understanding a blog author's perspective and biases
- Analyzing political leanings of publications
- Comparing perspectives across different blogs
- Critical reading and media literacy

[View Details](skills/blog-profile-analyzer/README.md) | [Download Latest](https://github.com/alecf/claude-skills/releases/latest/download/blog-profile-analyzer-latest.zip)

## Installation

### Quick Install (Recommended)

Install any skill with a single command:

```bash
curl -sSL https://raw.githubusercontent.com/alecf/claude-skills/main/scripts/install.sh | bash -s SKILL_NAME
```

**Example:**
```bash
curl -sSL https://raw.githubusercontent.com/alecf/claude-skills/main/scripts/install.sh | bash -s blog-profile-analyzer
```

Install multiple skills at once:
```bash
curl -sSL https://raw.githubusercontent.com/alecf/claude-skills/main/scripts/install.sh | bash -s skill1 skill2 skill3
```

### Manual Installation

1. Download the skill zip from the [Releases](https://github.com/alecf/claude-skills/releases) page
2. Extract the contents to `~/.claude/skills/`
3. Restart Claude Desktop

**Example:**
```bash
cd ~/.claude/skills
unzip ~/Downloads/blog-profile-analyzer-v1.0.0.zip
```

### Using the Skills

After installation:
1. Restart Claude Desktop
2. The skills will be automatically available
3. Claude will use them when appropriate, or you can invoke them explicitly

## What Are Claude Skills?

Skills are specialized prompts that give Claude Code additional capabilities for specific tasks. They provide:

- **Focused expertise** - Deep knowledge for specific domains or tasks
- **Consistent behavior** - Standardized approaches to common workflows
- **Reusable solutions** - Share and install proven techniques

## Requirements

- [Claude Desktop](https://claude.com/claude-code) installed
- For CLI installation: `curl`, `unzip`, and `jq` installed

**Install dependencies:**

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

### Skill Not Appearing After Installation

1. Verify installation: `ls ~/.claude/skills/`
2. Check the skill directory exists: `ls ~/.claude/skills/SKILL_NAME/`
3. Completely restart Claude Desktop (quit and reopen)

### Installation Failed

1. Check you have the required dependencies: `jq --version`
2. Verify the skill name is correct (see Available Skills above)
3. Try manual installation instead

### Skill Not Working as Expected

1. Check the skill's README for usage instructions: `cat ~/.claude/skills/SKILL_NAME/README.md`
2. Verify you're using the latest version
3. Try reinstalling: the installer will automatically replace the existing version

## Uninstalling Skills

To remove a skill:

```bash
rm -rf ~/.claude/skills/SKILL_NAME
```

Then restart Claude Desktop.

## Finding More Skills

Browse all available skills in the [skills/](skills/) directory or check the [Releases](https://github.com/alecf/claude-skills/releases) page for the latest versions.

## Contributing Your Own Skills

Want to create and share your own skills? See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed instructions on creating, testing, and submitting skills to this repository.

## Support

- **Issues**: Report problems or request features via [GitHub Issues](https://github.com/alecf/claude-skills/issues)
- **Discussions**: Ask questions or share ideas in [GitHub Discussions](https://github.com/alecf/claude-skills/discussions)

## License

Each skill may have its own license. See individual skill directories for details.
