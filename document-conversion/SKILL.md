---
name: document-conversion
description: Convert documents between Markdown, HTML, PDF, and DOCX formats using Python. Use when the user needs to transform a document from one format to another, generate a PDF from markdown, create a Word doc from HTML, or any cross-format conversion task.
metadata:
  author: quick2cowork
  version: "1.0"
  source: amazon-quick/document_conversion
compatibility: Requires Python 3.10+ with packages markdown, reportlab, python-docx, htmldocx, mammoth, python-pptx
---

# Document Conversion

Convert documents between Markdown, HTML, PDF, and DOCX using pure-Python libraries. No external binaries required.

## Available Libraries

| Library | Import | Purpose |
|---------|--------|---------|
| `markdown` | `import markdown` | Markdown → HTML |
| `reportlab` | `from reportlab.pdfgen import canvas` | Create PDF |
| `python-docx` | `from docx import Document` | Create/edit DOCX |
| `htmldocx` | `from htmldocx import HtmlToDocx` | HTML → DOCX |
| `mammoth` | `import mammoth` | DOCX → HTML/Markdown |
| `python-pptx` | `from pptx import Presentation` | Create/edit PPTX |

## Conversion Map

```
        markdown          reportlab
  MD ──────────→ HTML ──────────────→ PDF
                  ↕ htmldocx / mammoth
                 DOCX
```

## Conversion Recipes

### Markdown → HTML

```python
import markdown

md_text = open("input.md").read()
html = markdown.markdown(md_text, extensions=["tables", "fenced_code", "toc", "attr_list"])

with open("output.html", "w") as f:
    f.write(html)
```

### Markdown → PDF

```python
import markdown
from reportlab.lib.pagesizes import letter
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer
from reportlab.lib.styles import getSampleStyleSheet

md_text = open("input.md").read()
html = markdown.markdown(md_text, extensions=["tables", "fenced_code", "toc", "attr_list"])

doc = SimpleDocTemplate("output.pdf", pagesize=letter)
styles = getSampleStyleSheet()
story = [Paragraph(html, styles["Normal"])]
doc.build(story)
```

### Markdown → DOCX

```python
import markdown
from htmldocx import HtmlToDocx

md_text = open("input.md").read()
html = markdown.markdown(md_text, extensions=["tables", "fenced_code"])

parser = HtmlToDocx()
docx = parser.parse_html_string(html)
docx.save("output.docx")
```

### HTML → PDF

```python
from reportlab.lib.pagesizes import letter
from reportlab.platypus import SimpleDocTemplate, Paragraph
from reportlab.lib.styles import getSampleStyleSheet

html = open("input.html").read()
doc = SimpleDocTemplate("output.pdf", pagesize=letter)
styles = getSampleStyleSheet()
story = [Paragraph(html, styles["Normal"])]
doc.build(story)
```

### HTML → DOCX

```python
from htmldocx import HtmlToDocx

html = open("input.html").read()
parser = HtmlToDocx()
docx = parser.parse_html_string(html)
docx.save("output.docx")
```

### DOCX → HTML

```python
import mammoth

with open("input.docx", "rb") as f:
    result = mammoth.convert_to_html(f)
    html = result.value
    # result.messages contains any warnings
```

### DOCX → Markdown

```python
import mammoth

with open("input.docx", "rb") as f:
    result = mammoth.convert_to_markdown(f)
    md_text = result.value

with open("output.md", "w") as f:
    f.write(md_text)
```

### DOCX → PDF (via HTML intermediate)

```python
import mammoth
from reportlab.lib.pagesizes import letter
from reportlab.platypus import SimpleDocTemplate, Paragraph
from reportlab.lib.styles import getSampleStyleSheet

with open("input.docx", "rb") as f:
    html = mammoth.convert_to_html(f).value

doc = SimpleDocTemplate("output.pdf", pagesize=letter)
styles = getSampleStyleSheet()
story = [Paragraph(html, styles["Normal"])]
doc.build(story)
```

## Creating Documents from Scratch

### DOCX from scratch

```python
from docx import Document
from docx.shared import Inches, Pt

doc = Document()
doc.add_heading("Report Title", level=0)
doc.add_paragraph("Introduction paragraph.")
doc.add_heading("Section 1", level=1)
doc.add_paragraph("Content here.")

table = doc.add_table(rows=3, cols=3, style="Table Grid")
for i, row in enumerate(table.rows):
    for j, cell in enumerate(row.cells):
        cell.text = f"Row {i+1}, Col {j+1}"

doc.save("report.docx")
```

### PPTX from scratch

```python
from pptx import Presentation
from pptx.util import Inches, Pt

prs = Presentation()

slide = prs.slides.add_slide(prs.slide_layouts[0])
slide.shapes.title.text = "Presentation Title"
slide.placeholders[1].text = "Subtitle"

slide = prs.slides.add_slide(prs.slide_layouts[1])
slide.shapes.title.text = "Key Points"
body = slide.placeholders[1]
tf = body.text_frame
tf.text = "First point"
tf.add_paragraph().text = "Second point"
tf.add_paragraph().text = "Third point"

prs.save("presentation.pptx")
```

## Tips

- Always use `extensions=["tables", "fenced_code"]` with the markdown library for proper table and code block support.
- ReportLab's `Paragraph` supports a subset of HTML tags (b, i, u, br, font, a, img, sub, sup). For complex HTML, break it into multiple Paragraphs.
- For DOCX → PDF, go through HTML as the intermediate format.
- `mammoth` preserves semantic structure (headings, lists, tables) but strips visual formatting — it produces clean HTML.
- For complex PDF layouts with headers/footers, use ReportLab's `PageTemplate` and `Frame` system.
- For styled PDFs, define custom `ParagraphStyle` objects with font, size, color, and spacing.
