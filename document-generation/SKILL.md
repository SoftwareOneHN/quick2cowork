---
name: document-generation
description: Create professional documents from scratch — Word (.docx), PDF, PowerPoint (.pptx), and Excel (.xlsx). Use when the user wants to generate a report, presentation, spreadsheet, or formatted document programmatically using Python or JavaScript libraries.
metadata:
  author: quick2cowork
  version: "1.0"
  source: amazon-quick/canvas_docx+canvas_pdf+canvas_pptx+canvas_xlsx
compatibility: Requires Python 3.10+ with python-docx, reportlab, python-pptx, openpyxl, xlsxwriter. Or Node.js with pptxgenjs, docx.
---

# Document Generation

Create professional documents programmatically. Covers Word, PDF, PowerPoint, and Excel.

## Library Matrix

| Format | Creation | Editing | Key Import |
|--------|----------|---------|------------|
| DOCX | `python-docx` or `docx` (JS) | `python-docx` | `from docx import Document` |
| PDF | `reportlab` | N/A (recreate) | `from reportlab.platypus import SimpleDocTemplate` |
| PPTX | `python-pptx` or `pptxgenjs` (JS) | `python-pptx` | `from pptx import Presentation` |
| XLSX | `xlsxwriter` (create) | `openpyxl` (edit) | `import xlsxwriter` / `from openpyxl import load_workbook` |

## General Workflow

1. **Plan structure** — outline sections/slides/sheets before coding
2. **Build incrementally** — one section at a time, save after each
3. **Verify** — check output matches expectations
4. **Deliver** — provide the final file to user

## Word Documents (DOCX)

### From scratch (python-docx)

```python
from docx import Document
from docx.shared import Inches, Pt, Cm
from docx.enum.text import WD_ALIGN_PARAGRAPH

doc = Document()

# Title
doc.add_heading("Quarterly Report", level=0)
doc.add_paragraph("Generated on 2026-06-11")

# Section
doc.add_heading("Executive Summary", level=1)
doc.add_paragraph("Key findings from this quarter...")

# Table
table = doc.add_table(rows=4, cols=3, style="Table Grid")
headers = ["Metric", "Q1", "Q2"]
for i, h in enumerate(headers):
    table.rows[0].cells[i].text = h

# Save
doc.save("report.docx")
```

### Key features
- Headings (levels 0-9)
- Paragraphs with styles (Normal, BodyText, Quote)
- Tables with merged cells
- Images: `doc.add_picture("chart.png", width=Inches(5))`
- Page breaks: `doc.add_page_break()`
- Headers/footers via sections

## PDF Documents (ReportLab)

### From scratch

```python
from reportlab.lib.pagesizes import LETTER
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Table, PageBreak
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.units import inch
from reportlab.lib.colors import HexColor

doc = SimpleDocTemplate("report.pdf", pagesize=LETTER,
                        leftMargin=1*inch, rightMargin=1*inch,
                        topMargin=1*inch, bottomMargin=1*inch)
styles = getSampleStyleSheet()
story = []

# Custom style
title_style = ParagraphStyle("CustomTitle", parent=styles["Title"],
                             textColor=HexColor("#0052CC"), fontSize=24)

story.append(Paragraph("Quarterly Report", title_style))
story.append(Spacer(1, 0.5*inch))
story.append(Paragraph("Executive summary content...", styles["Normal"]))
story.append(PageBreak())
story.append(Paragraph("Section 2", styles["Heading1"]))

doc.build(story)
```

### Key features
- Flowables: Paragraph, Table, Image, Spacer, PageBreak
- Custom ParagraphStyles (font, size, color, spacing)
- Tables with column widths and cell styles
- Page templates for headers/footers
- Images: `Image("chart.png", width=5*inch, height=3*inch)`

## PowerPoint (python-pptx)

### From scratch

```python
from pptx import Presentation
from pptx.util import Inches, Pt, Emu
from pptx.dml.color import RGBColor
from pptx.enum.text import PP_ALIGN

prs = Presentation()

# Title slide
slide = prs.slides.add_slide(prs.slide_layouts[0])
slide.shapes.title.text = "Q2 Results"
slide.placeholders[1].text = "Engineering Team"

# Content slide
slide = prs.slides.add_slide(prs.slide_layouts[1])
slide.shapes.title.text = "Key Metrics"
tf = slide.placeholders[1].text_frame
tf.text = "Revenue: $2.1M (+15%)"
tf.add_paragraph().text = "Users: 50K (+22%)"
tf.add_paragraph().text = "NPS: 72 (+5)"

# Blank slide with shapes
slide = prs.slides.add_slide(prs.slide_layouts[6])
left = Inches(1); top = Inches(2)
width = Inches(3); height = Inches(1.5)
shape = slide.shapes.add_shape(1, left, top, width, height)  # rectangle
shape.fill.solid()
shape.fill.fore_color.rgb = RGBColor(0x00, 0x52, 0xCC)

prs.save("presentation.pptx")
```

### Key features
- Slide layouts (Title, Content, Blank, etc.)
- Shapes with fill, border, shadow
- Text frames with formatting
- Charts (built-in chart support)
- Images and tables
- Slide masters for branding

## Excel (xlsxwriter for creation)

### From scratch

```python
import xlsxwriter

wb = xlsxwriter.Workbook("report.xlsx")

# Formats
header_fmt = wb.add_format({"bold": True, "bg_color": "#0052CC",
                            "font_color": "white", "border": 1})
money_fmt = wb.add_format({"num_format": "$#,##0.00"})

# Sheet 1
ws = wb.add_worksheet("Summary")
headers = ["Month", "Revenue", "Costs", "Profit"]
for col, h in enumerate(headers):
    ws.write(0, col, h, header_fmt)

data = [["Jan", 120000, 80000], ["Feb", 150000, 90000], ["Mar", 170000, 95000]]
for row, d in enumerate(data, 1):
    ws.write(row, 0, d[0])
    ws.write(row, 1, d[1], money_fmt)
    ws.write(row, 2, d[2], money_fmt)
    ws.write(row, 3, d[1] - d[2], money_fmt)

# Auto-fit columns
ws.set_column("A:A", 12)
ws.set_column("B:D", 15)

# Chart
chart = wb.add_chart({"type": "column"})
chart.add_series({"name": "Revenue", "values": "=Summary!$B$2:$B$4",
                  "categories": "=Summary!$A$2:$A$4"})
ws.insert_chart("F2", chart)

wb.close()
```

### For editing existing files (openpyxl)

```python
from openpyxl import load_workbook

wb = load_workbook("existing.xlsx")
ws = wb.active
ws["A1"] = "Updated value"
wb.save("existing.xlsx")
```

## Design Tips

- **Structure first**: Plan sections/slides/sheets before coding
- **Consistent styling**: Define styles/formats once, reuse everywhere
- **Progressive complexity**: Start simple, add formatting after content works
- **Test incrementally**: Save and check after each major section
- **Professional touches**: Headers/footers, page numbers, consistent colors

See [references/advanced-patterns.md](references/advanced-patterns.md) for templates, charts, and complex layouts.
