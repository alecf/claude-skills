# Blog Profile Analyzer

## Description

Analyzes blogs and online publications to create comprehensive profiles of authors' perspectives, biases, political leanings, and worldviews. This skill helps you understand the lens through which a blog author sees the world, making it easier to critically evaluate their work.

## Usage

Use this skill when you want to:
- Understand a blog author's perspective and biases
- Analyze the political leanings of a publication
- Profile a blog's worldview and values
- Compare perspectives across different blogs

### How to Invoke

Simply ask Claude to analyze a blog:

```
Analyze the blog at example.substack.com for the author's perspective
```

Or:

```
Can you profile the political leanings of [Blog Name]?
```

## What It Does

The skill will:
1. Fetch and analyze 5-10 representative posts from the blog
2. Examine the author's "About" page if available
3. Analyze content across multiple dimensions:
   - Core beliefs and values
   - Political and ideological leanings
   - Biases and blind spots
   - Rhetorical style
   - Epistemology (how they know what they know)
4. Create a concise, one-page profile (~800-1000 words)
5. Save the analysis to a markdown file

## Output

The skill generates a structured profile including:
- **Executive Summary**: Quick overview of the author's perspective
- **Political & Worldview Profile**: Detailed political and ideological analysis
- **Core Values, Biases & Blind Spots**: What drives the author and what they miss
- **How to Read This Author**: Practical guidance for critically reading their work
- **Evidence & Style**: How they argue and what they consider evidence
- **Key Quotes**: Representative excerpts from their writing

## Examples

### Example 1: Analyze a Specific Blog
```
User: Analyze the blog at arctotherium.substack.com for the author's perspective and biases

Claude: I'll analyze that Substack blog to profile the author's perspective.
Let me start by fetching the main page and then analyze several representative posts.

[Proceeds with comprehensive analysis]
```

### Example 2: Compare Multiple Blogs
```
User: Compare the political leanings of Marginal Revolution and Astral Codex Ten

Claude: I'll analyze both blogs separately first, then provide a comparison...

[Analyzes each blog and creates comparative summary]
```

## Requirements

This skill requires:
- Internet access (uses WebFetch and WebSearch)
- Time to complete (multiple web fetches required)
- Access to blog content (some blogs may be paywalled)

## Notes

- Analysis is objective and descriptive, not judgmental
- Quality depends on access to representative posts
- Some blogs may have limited free content
- Designed for understanding perspectives, not for malicious profiling
- Works best with blogs that have 5+ accessible posts

## Version History

### 1.0.0
- Initial release
- Supports blog profiling with comprehensive analysis framework
- Generates concise, structured profiles
- Includes comparative analysis capability
