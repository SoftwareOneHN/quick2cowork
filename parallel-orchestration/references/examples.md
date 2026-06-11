# Parallel Orchestration Examples

## Example 1: Invoice Data Extraction (45 PDFs)

**Decision Card**: 1-per-task recommended (45 tasks)

**Schema**:
```python
class LineItem(BaseModel):
    description: str
    quantity: float
    unit_price: float
    amount: float

class InvoiceExtraction(BaseModel):
    vendor_name: str
    date: str  # YYYY-MM-DD
    total: float
    line_items: List[LineItem]
```

**Objective template**:
```
Extract structured data from the invoice in the manifest.

1. Read manifest at {manifest_path} — contains 1 PDF path.
2. Read the ENTIRE PDF. Extract all fields per InvoiceExtraction schema.
3. Normalize dates to YYYY-MM-DD. If a field is missing, use null.
4. Validate the result against the schema.
5. Return the validated data.

Schema:
{schema_source}

Notes:
- Line items may span multiple pages — read the full document.
- Do not guess values. Missing = null.
```

**Aggregation**:
```python
validated = []
for task_result in results:
    try:
        validated.append(InvoiceExtraction.model_validate(task_result))
    except ValidationError:
        errors.append(task_result)

# Export to CSV/DataFrame
```

---

## Example 2: Competitive Research (8 companies)

**Decision Card**: 1-per-task (8 tasks, each needs web search)

**Schema**:
```python
class CompetitorProfile(BaseModel):
    company_name: str
    primary_products: List[str]
    target_market: str
    estimated_revenue: Optional[str]
    key_differentiators: List[str]
    weaknesses: List[str]
    recent_developments: List[str]
```

**Objective template**:
```
Research {company_name} as part of a competitive landscape analysis.

1. Search for recent information: products, market position, revenue, news.
2. Check 3-5 sources for accuracy.
3. Construct a CompetitorProfile with all fields.
4. Return validated data.

Schema:
{schema_source}

Notes:
- Prefer sources from the last 12 months.
- recent_developments = launches, acquisitions, partnerships, leadership changes.
- If revenue is not public, estimate range or set null.
```

---

## Example 3: Multi-Perspective Code Review

**Decision Card**: 3 reviewers × N files

**Perspectives**: Security, Performance, Maintainability

**Schema**:
```python
class Finding(BaseModel):
    file: str
    line: int
    severity: str  # critical, high, medium, low
    issue: str
    suggestion: str

class CodeReview(BaseModel):
    perspective: str
    findings: List[Finding]
    summary: str
```

**Objective template**:
```
Review the code from a {perspective} perspective.

1. Read the files in manifest at {manifest_path}.
2. For each file, identify issues related to {criteria}.
3. Rate severity: critical > high > medium > low.
4. Provide a concrete suggestion for each finding.
5. Write a 2-3 sentence overall assessment.
6. Return validated CodeReview data.

Focus: {criteria_detail}

Notes:
- Focus on changed lines but consider surrounding context.
- If no issues found, return empty findings with a clean summary.
```

**Aggregation**: Group findings by file, sort by severity, identify themes across perspectives.

---

## Example 4: Pipeline (Scrape → Extract → Validate)

**Stage 1**: Scrape 20 URLs → raw HTML files
**Stage 2**: Extract structured data from each HTML
**Stage 3**: Validate, deduplicate, enrich

Between stages:
- Validate stage output before launching next
- Handle partial failures (proceed with successful items)
- Present Decision Card if failure rate > 20%
