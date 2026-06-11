---
name: html-design
description: Design guidelines and theme tokens for generating polished HTML artifacts — dashboards, reports, cards, tables, and data visualizations. Load this skill when creating any styled HTML output that should look professional and theme-aware.
metadata:
  author: quick2cowork
  version: "1.0"
  source: amazon-quick/html_design
compatibility: Works in any modern browser. Charts require Highcharts 12.x.
---

# HTML Design

Guidelines for creating polished, theme-aware HTML widgets and artifacts.

## Theme Tokens (CSS Custom Properties)

Use these variables for consistent styling. Define fallbacks in `:root` for standalone files:

```css
:root {
  /* Backgrounds */
  --color-bg: #ffffff;
  --color-bg-secondary: #f4f5f7;
  --color-surface: #ffffff;
  --color-surface-hover: #f0f1f3;
  --color-surface-active: #e8e9ec;

  /* Text */
  --color-text: #172b4d;
  --color-text-secondary: #44546f;
  --color-text-muted: #8993a4;

  /* Borders */
  --color-border: #dfe1e6;
  --color-border-light: #ebecf0;

  /* Accent / Status */
  --color-primary: #0052CC;
  --color-success: #36b37e;
  --color-error: #de350b;
  --color-warning: #ff991f;
  --color-info: #0065ff;

  /* Typography */
  --font-sans: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
  --font-mono: 'SF Mono', Consolas, monospace;

  /* Spacing & Shape */
  --radius-sm: 4px;
  --radius-md: 8px;
  --radius-pill: 100px;
}
```

## Design Principles

### 1. Content First
- Lead with data, not chrome
- Generous whitespace
- Every element earns its place

### 2. Visual Hierarchy
- One focal point per widget
- `--color-text` for primary, `--color-text-secondary` for supporting, `--color-text-muted` for labels
- Size contrast > colour contrast

### 3. Restrained Colour
- `--color-bg-secondary` for cards/surfaces
- Reserve `--color-primary` for interactive elements only
- Status colours only for actual status

### 4. Typography
- `font-family: var(--font-sans)` on body
- `var(--font-mono)` for numbers, code, data cells
- Max 2-3 font sizes per widget
- Line height 1.4-1.6 for body text

### 5. Spacing & Layout
- Consistent: 8, 12, 16, 24, 32px (multiples of 4)
- `border-radius: var(--radius-md)` for cards
- CSS Grid or Flexbox — never tables for layout

### 6. Animation (light)
- Chart entry: fade-in on load (300-600ms)
- Hover: `transition: all 0.15s ease`
- Respect `prefers-reduced-motion`
- Keep durations 150-300ms

### 7. Interactivity
- Tooltips on data points
- Sort buttons on table headers
- `cursor: pointer` + visible hover states
- Use `<button>` not `<div>` for clickables

## Common Patterns

### Dashboard Card

```css
.card {
  background: var(--color-bg-secondary);
  border: 1px solid var(--color-border-light);
  border-radius: var(--radius-md);
  padding: 20px;
}
.card-label {
  color: var(--color-text-muted);
  font-size: 12px;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}
.card-value {
  color: var(--color-text);
  font-size: 28px;
  font-weight: 600;
  font-family: var(--font-mono);
}
.card-delta.positive { color: var(--color-success); }
.card-delta.negative { color: var(--color-error); }
```

### Styled Table

```css
table { width: 100%; border-collapse: collapse; font-size: 13px; }
th {
  text-align: left;
  color: var(--color-text-muted);
  font-weight: 500;
  padding: 8px 12px;
  border-bottom: 1px solid var(--color-border);
}
td {
  padding: 8px 12px;
  color: var(--color-text);
  border-bottom: 1px solid var(--color-border-light);
}
tr:hover td { background: var(--color-surface-hover); }
```

### Fade-in Entrance

```css
@media (prefers-reduced-motion: no-preference) {
  .fade-in {
    animation: fadeIn 0.4s ease-out both;
  }
  @keyframes fadeIn {
    from { opacity: 0; transform: translateY(8px); }
    to { opacity: 1; transform: none; }
  }
}
```

## Complete Standalone Template

```html
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <style>
    :root {
      --color-bg: #ffffff;
      --color-bg-secondary: #f4f5f7;
      --color-text: #172b4d;
      --color-text-secondary: #44546f;
      --color-text-muted: #8993a4;
      --color-border-light: #ebecf0;
      --color-border: #dfe1e6;
      --color-surface: #ffffff;
      --color-primary: #0052CC;
      --color-success: #36b37e;
      --color-error: #de350b;
      --font-sans: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
      --font-mono: 'SF Mono', Consolas, monospace;
      --radius-md: 8px;
    }
    body {
      background: var(--color-bg);
      font-family: var(--font-sans);
      color: var(--color-text);
      padding: 24px;
      margin: 0;
    }
    .card {
      background: var(--color-bg-secondary);
      border: 1px solid var(--color-border-light);
      border-radius: var(--radius-md);
      padding: 20px;
    }
  </style>
</head>
<body>
  <h1>Dashboard</h1>
  <div class="card">
    <!-- Content here -->
  </div>
</body>
</html>
```

## CDN Libraries (allowed)

| Library | CDN URL |
|---------|---------|
| Tailwind CSS | `https://cdn.tailwindcss.com` |
| Lucide Icons | `https://cdn.jsdelivr.net/npm/lucide-static@latest/lucide.min.js` |
| Font Awesome | `https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css` |
| Chart.js | `https://cdn.jsdelivr.net/npm/chart.js@4/dist/chart.umd.min.js` |
| D3 | `https://cdn.jsdelivr.net/npm/d3@7/dist/d3.min.js` |
| Mermaid | `https://cdn.jsdelivr.net/npm/mermaid@10/dist/mermaid.min.js` |
| Leaflet | `https://cdn.jsdelivr.net/npm/leaflet@1/dist/leaflet.js` |
| KaTeX | `https://cdn.jsdelivr.net/npm/katex@0.16/dist/katex.min.js` |
| Three.js | `https://cdn.jsdelivr.net/npm/three@0.160/build/three.min.js` |
| Day.js | `https://cdn.jsdelivr.net/npm/dayjs@1/dayjs.min.js` |
