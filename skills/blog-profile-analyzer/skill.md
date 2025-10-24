# Blog Profile Analyzer

This skill helps you analyze blogs and online publications to understand the author's perspective, biases, political leanings, and overall worldview.

## Instructions

When asked to analyze a blog or given a blog URL for profiling:

1. **Initial Discovery**
   - If given a specific blog URL, start there
   - If given just a blog name or author, use WebSearch to find the blog's main URL
   - Navigate to the blog's main page or about page first

2. **Content Collection Strategy**
   - Fetch the blog's main page to understand structure
   - Look for an "About" or "About Me" page for explicit author statements
   - Identify 5-10 recent or representative posts spanning different topics
   - For each post, use WebFetch to extract the full content
   - Include a mix of content types - bias and perspective are often revealed in how authors present factual information, not just in explicit opinion pieces

3. **Analysis Framework**

   Analyze the collected content across these dimensions:

   **Core Beliefs & Values:**
   - What principles or values appear most important to the author?
   - What topics do they write about most frequently?
   - What causes or issues do they champion?

   **Political & Ideological Leanings:**
   - Where do they fall on political spectrums (left/right, libertarian/authoritarian, etc.)?
   - Do they align with particular political movements or philosophies?
   - How do they discuss different political figures, parties, or ideologies?

   **Biases & Blind Spots:**
   - What assumptions do they make without questioning?
   - Which perspectives or counterarguments do they rarely engage with?
   - Are there topics they avoid or viewpoints they dismiss?

   **Rhetorical Style:**
   - Are they combative, conciliatory, academic, populist?
   - Do they use data and evidence, or rely more on narrative and emotion?
   - How do they treat opposing viewpoints?

   **Epistemology (How They Know What They Know):**
   - What sources do they trust or cite frequently?
   - How do they approach uncertainty and evidence?
   - Do they emphasize lived experience, data, tradition, or other forms of knowledge?

4. **Output Format**

   CRITICAL: Keep the entire profile to roughly one page of text (~800-1000 words). Be concise and high-signal.

   Create a comprehensive but readable profile document with:

   ```markdown
   # Blog Profile: [Blog Name]

   **Author:** [Name] | **URL:** [Main URL] | **Date:** [Current Date] | **Posts Analyzed:** [Number]

   ## Executive Summary
   [Single dense paragraph (4-6 sentences) capturing: main focus, political orientation, writing style, and key distinguishing characteristics. Make every sentence count.]

   ## Political & Worldview Profile
   [1-2 paragraphs combining political leanings with matching ideologies. Name specific traditions (e.g., "demographic realism," "effective altruism," "Burkean conservatism") and explain alignments/divergences. Use concrete examples.]

   ## Core Values, Biases & Blind Spots
   [1-2 paragraphs that efficiently combine: (1) what the author values most, (2) their main biases and assumptions, and (3) what they overlook or minimize. Focus on patterns that matter for understanding their work.]

   ## How to Read This Author
   [1-2 dense paragraphs with actionable guidance: What lens do they bring? What questions should you ask? What's likely emphasized vs. downplayed? What evidence tends to be absent? This is the most important practical section.]

   ## Evidence & Style
   [1 paragraph combining rhetorical approach and epistemology: How do they argue (academic/populist/combative)? What counts as evidence (data/narrative/lived experience)? What sources do they trust?]

   ## Key Quotes
   [3-5 representative quotes with minimal context]

   ## Analysis Notes
   [1-2 sentences on posts analyzed and confidence level]
   ```

5. **Best Practices**

   - TARGET LENGTH: ~800-1000 words total. Be ruthlessly concise while remaining substantive.
   - LANGUAGE & STYLE: Use straightforward, clear language at roughly a high school reading level. Avoid adopting the complex vocabulary or sentence structure of the blog being analyzed. Write in a consistent, accessible voice that any educated adult can easily understand.
   - Write dense, information-rich paragraphs - every sentence should add value
   - Combine related sections (politics + worldview, values + biases + blind spots, rhetoric + epistemology)
   - Be objective and factual - describe, don't judge
   - Use specific examples but weave them in efficiently
   - Eliminate redundancy - don't repeat points across sections
   - Focus on patterns that matter for understanding future posts by this author
   - Remember: bias shows up in how authors present facts, not just in opinion pieces
   - The "How to Read This Author" section is the most critical practical takeaway
   - Prioritize actionable insights over comprehensive coverage
   - Save the profile to a file for the user's reference

6. **Output Location**
   - Save the analysis to `blog-profile-[blog-name]-[date].md` in the current directory
   - Let the user know where the file was saved

## Examples

### Example 1: Direct URL
User: "Analyze the blog at arctotherium.substack.com for the author's perspective and biases"

Response: I'll analyze that Substack blog to profile the author's perspective. Let me start by fetching the main page and then analyze several representative posts.

[Proceeds with analysis following the framework above]

### Example 2: Blog Name
User: "Can you profile the perspective of the author of Marginal Revolution?"

Response: I'll search for and analyze the Marginal Revolution blog to understand the authors' perspectives and biases.

[Uses WebSearch to find the blog, then proceeds with analysis]

### Example 3: Comparative Analysis
User: "Compare the political leanings of blog A and blog B"

Response: I'll analyze both blogs separately first, then provide a comparison. Let me start with blog A...

[Analyzes each blog, then creates a comparative summary]

## Notes

- This skill requires multiple WebFetch calls and can take time to complete
- Some blogs may be behind paywalls or have limited free content
- The analysis quality depends on having access to multiple representative posts
- Always maintain objectivity and present evidence for analytical claims
- This is designed for defensive analysis and understanding perspectives, not for profiling individuals for malicious purposes
