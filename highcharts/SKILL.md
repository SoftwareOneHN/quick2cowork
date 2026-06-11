---
name: highcharts
description: Highcharts 12.x API reference for all charts and data visualizations. Load this skill when generating any chart — line, bar, pie, heatmap, sankey, treemap, gauge, network graph, org chart, timeline, wordcloud, and more. Covers chart types, required modules, theming, tooltips, drilldown, responsive config, and performance.
metadata:
  author: quick2cowork
  version: "1.0"
  source: amazon-quick/highcharts
compatibility: Requires Highcharts 12.x (paid license or CDN). Works in any HTML environment.
---

# Highcharts Reference

Complete reference for building Highcharts visualizations. Covers all chart types, required modules, theming, and best practices.

## Loading Highcharts

Core library first, then modules:

```html
<script src="https://cdn.jsdelivr.net/npm/highcharts@12.1.2/highcharts.js"></script>
<script src="https://cdn.jsdelivr.net/npm/highcharts@12.1.2/modules/accessibility.js"></script>
```

For Stock charts, load highstock instead of core:
```html
<script src="https://cdn.jsdelivr.net/npm/highcharts@12.1.2/highstock.js"></script>
```

For Maps, load highmaps instead of core:
```html
<script src="https://cdn.jsdelivr.net/npm/highcharts@12.1.2/highmaps.js"></script>
```

## Chart Types & Required Modules

### Core (no extra module)

| Type | `type:` value | Best for |
|------|--------------|----------|
| Line | `'line'` | Trends over time |
| Spline | `'spline'` | Smooth trends |
| Area | `'area'` | Volume over time |
| Column | `'column'` | Comparing categories |
| Bar | `'bar'` | Horizontal comparisons |
| Pie | `'pie'` | Parts of a whole (donut via `innerSize`) |
| Scatter | `'scatter'` | Correlations |
| Bubble | `'bubble'` | 3-variable correlations |
| Waterfall | `'waterfall'` | Sequential +/- changes |
| Gauge | `'gauge'` | Speedometer dials |
| Box Plot | `'boxplot'` | Statistical distributions |
| Polar/Radar | any type + `chart.polar: true` | Circular comparisons |

### Requires extra modules

| Type | Module(s) needed | Best for |
|------|-----------------|----------|
| Heatmap | `modules/heatmap` | Matrix/grid with color |
| Treemap | `modules/treemap` | Hierarchical proportions |
| Sankey | `modules/sankey` | Flow between nodes |
| Network Graph | `modules/networkgraph` | Relationships |
| Organization | `modules/sankey` + `modules/organization` | Org charts |
| Sunburst | `modules/sunburst` | Hierarchical rings |
| Solid Gauge | `modules/solid-gauge` | KPI meters |
| Funnel | `modules/funnel` | Conversion funnels |
| Timeline | `modules/timeline` | Event sequences |
| Word Cloud | `modules/wordcloud` | Text frequency |
| Venn | `modules/venn` | Set overlaps |
| Dumbbell | `modules/dumbbell` | Before/after ranges |
| X-Range | `modules/xrange` | Gantt-like ranges |
| Histogram | `modules/histogram-bellcurve` | Distributions |
| Arc Diagram | `modules/sankey` + `modules/arc-diagram` | Connection arcs |
| Streamgraph | `modules/streamgraph` | Stacked center baseline |
| Variwide | `modules/variwide` | Variable-width columns |
| Packed Bubble | `highcharts-more` | Clustered magnitude |

## Basic Chart Structure

```js
Highcharts.chart('container', {
  chart: {
    type: 'line',
    backgroundColor: 'transparent',
  },
  title: { text: 'My Chart' },
  subtitle: { text: 'Source: Example Data' },
  xAxis: {
    categories: ['Jan', 'Feb', 'Mar', 'Apr'],
  },
  yAxis: {
    title: { text: 'Values' },
  },
  series: [{
    name: 'Series 1',
    data: [1, 3, 2, 4],
  }],
  credits: { enabled: false },
  accessibility: { enabled: true },
});
```

## Series Data Formats

1. **Simple values** — y-values only: `data: [0, 5, 3, 5]`
2. **Array pairs** — [x, y]: `data: [[5, 2], [6, 3], [8, 2]]`
3. **Object points** — full control: `data: [{ name: 'A', y: 10, color: '#f00' }]`

## Theming

```js
const s = getComputedStyle(document.documentElement);
const get = (v) => s.getPropertyValue(v).trim();

Highcharts.chart('container', {
  chart: {
    backgroundColor: 'transparent',
    style: { fontFamily: get('--font-sans') || 'system-ui, sans-serif' },
  },
  title: { style: { color: get('--color-text') || '#1a1a1a' } },
  xAxis: {
    labels: { style: { color: get('--color-text-secondary') || '#666' } },
    gridLineColor: get('--color-border-light') || '#eee',
  },
  yAxis: {
    labels: { style: { color: get('--color-text-secondary') || '#666' } },
    gridLineColor: get('--color-border-light') || '#eee',
  },
  credits: { enabled: false },
});
```

## Tooltips

```js
tooltip: {
  shared: true,
  crosshairs: true,
  useHTML: true,
  headerFormat: '<b>{point.key}</b><br/>',
  pointFormat: '<span style="color:{series.color}">●</span> {series.name}: <b>{point.y:,.0f}</b><br/>',
}
```

## Drilldown

```js
series: [{
  name: 'Regions',
  colorByPoint: true,
  data: [
    { name: 'Americas', y: 45, drilldown: 'americas' },
    { name: 'Europe', y: 30, drilldown: 'europe' },
  ]
}],
drilldown: {
  series: [
    { id: 'americas', data: [['US', 30], ['Brazil', 10], ['Canada', 5]] },
    { id: 'europe', data: [['UK', 12], ['Germany', 10], ['France', 8]] },
  ]
}
```

## Stacking

```js
plotOptions: {
  column: { stacking: 'normal' }  // or 'percent' for 100%
}
```

## Multiple Y-Axes

```js
yAxis: [
  { title: { text: 'Revenue ($)' } },
  { title: { text: 'Units' }, opposite: true },
],
series: [
  { name: 'Revenue', type: 'column', data: [...], yAxis: 0 },
  { name: 'Units', type: 'line', data: [...], yAxis: 1 },
]
```

## Responsive

```js
responsive: {
  rules: [{
    condition: { maxWidth: 500 },
    chartOptions: {
      legend: { layout: 'horizontal', align: 'center', verticalAlign: 'bottom' },
    }
  }]
}
```

## Performance (100k+ points)

```html
<script src="https://cdn.jsdelivr.net/npm/highcharts@12.1.2/modules/boost.js"></script>
```
```js
boost: { useGPUTranslations: true },
series: [{ boostThreshold: 1, data: largeArray }]
```

## Common Pitfalls

1. **Error #17** — Missing module for chart type. Check the table above.
2. **Container not found** — Place `<script>` after the container div.
3. **White background** — Set `chart.backgroundColor: 'transparent'`.
4. **Credits link** — Disable: `credits: { enabled: false }`.
5. **Org chart** — Needs BOTH `modules/sankey` AND `modules/organization`.
6. **Treemap + colorAxis** — Needs BOTH `modules/treemap` AND `modules/heatmap`.
7. **Solid gauge** — Needs `modules/solid-gauge` (separate from core gauge).
8. **Pie donut** — Use `innerSize: '50%'`, not a separate type.

## Utility Functions

```js
Highcharts.numberFormat(1234567.89, 2, '.', ',')  // "1,234,567.89"
Highcharts.dateFormat('%Y-%m-%d', timestamp)
Highcharts.color('#ff0000').setOpacity(0.5).get() // "rgba(255,0,0,0.5)"
```

## Detailed References

For chart-type-specific configuration details, see:
- [references/chart-types.md](references/chart-types.md) — Pie, Heatmap, Sankey, Treemap, Network, Org, Waterfall, Gauge, Packed Bubble, Timeline configs
- [references/stock-maps.md](references/stock-maps.md) — Highstock and Highmaps specifics
