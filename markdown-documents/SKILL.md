---
name: markdown-documents
description: Create and edit rich Markdown documents with embedded SVG visualizations. Use when generating reports, documentation, or any structured text output as .md files.
metadata:
  author: quick2cowork
  version: "1.0"
  source: amazon-quick/canvas_md
---

# Markdown Documents

Create polished Markdown documents with support for rich formatting, tables, code blocks, and embedded SVG visualizations.

## Creating a Document

Write the document content to a `.md` file. Structure with headings, tables, code blocks, blockquotes, links, and images.

## Embedding Visualizations

When content benefits from charts or diagrams, generate SVG files and reference them:

```markdown
![Revenue by quarter](./revenue_chart.svg)
```

### SVG Generation Tips (Python/matplotlib)

```python
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

fig, ax = plt.subplots(figsize=(8, 4))
ax.bar(['Q1', 'Q2', 'Q3', 'Q4'], [120, 150, 170, 190])
ax.set_title('Revenue by Quarter')
fig.savefig('revenue_chart.svg', transparent=True, bbox_inches='tight')
plt.close(fig)
```

Best practices:
- `transparent=True` — works with both light and dark themes
- `matplotlib.use('Agg')` before importing pyplot (no display needed)
- `plt.close(fig)` after each save to free memory
- Generate all charts in a single script when possible
- Save as separate `.svg` files — do NOT embed raw SVG inline

## Document Structure Guide

```markdown
# Title

Brief introduction paragraph.

## Section 1

Content with **bold**, *italic*, and `inline code`.

### Subsection

- Bullet list item
- Another item

| Column A | Column B | Column C |
|----------|----------|----------|
| Data 1   | Data 2   | Data 3   |

## Section 2

> Blockquote for callouts or important notes.

```python
# Code block with syntax highlighting
def example():
    return "hello"
```

![Diagram](./diagram.svg)
```

## Tips

- Use heading levels consistently (H1 for title, H2 for sections, H3 for subsections)
- Keep tables simple — complex data is better as embedded charts
- Use code blocks with language tags for syntax highlighting
- Prefer relative paths for images
- Keep line length reasonable for readability in raw form
