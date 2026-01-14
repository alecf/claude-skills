# wakey-wakey

Keeps your Mac awake during Claude Code sessions.

## What it does

Adds a `PostToolUse` hook that runs after every tool invocation. The hook:

1. Kills any existing `caffeinate` process
2. Starts a new `caffeinate` process with a 5-minute timeout

This keeps your Mac awake as long as Claude is actively working, preventing sleep during long-running tasks.

## Installation

```
/plugin marketplace add alecf/claude-skills
/plugin install wakey-wakey@alecf-claude-skills
```

## How it works

Uses macOS's built-in `caffeinate` command with the `-u` flag (asserts user activity) and a 300-second timeout. Each tool use resets the timer, so your Mac stays awake during active sessions but will sleep normally when Claude is idle.
