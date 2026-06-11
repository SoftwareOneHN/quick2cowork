# Highcharts Chart-Type Configurations

Detailed configuration examples for chart types requiring modules.

## Pie / Donut

```js
series: [{
  type: 'pie',
  innerSize: '50%',    // donut; omit for solid pie
  data: [
    { name: 'Chrome', y: 65 },
    { name: 'Firefox', y: 20, sliced: true, selected: true },
    { name: 'Safari', y: 15 },
  ]
}]
```

## Heatmap

Requires: `modules/heatmap`. Data format: `[x, y, value]`.

```js
colorAxis: {
  min: 0,
  minColor: '#ffffff',
  maxColor: '#0052CC',
},
series: [{
  type: 'heatmap',
  data: [[0,0,10], [0,1,19], [1,0,92], [1,1,58]],
  dataLabels: { enabled: true, color: '#000' },
}]
```

## Sankey

Requires: `modules/sankey`. Data format: `{ from, to, weight }`.

```js
series: [{
  type: 'sankey',
  keys: ['from', 'to', 'weight'],
  data: [
    ['Oil', 'Transportation', 94],
    ['Oil', 'Industrial', 41],
    ['Coal', 'Electricity', 85],
  ],
  nodes: [{ id: 'Oil', color: '#ff991f' }],
}]
```

## Treemap

Requires: `modules/treemap` (+ `modules/heatmap` for colorAxis).

```js
series: [{
  type: 'treemap',
  layoutAlgorithm: 'squarified',
  allowTraversingTree: true,
  levels: [{
    level: 1,
    dataLabels: { enabled: true, align: 'left', verticalAlign: 'top' },
    borderWidth: 3,
  }],
  data: [
    { name: 'Region A', id: 'A', color: '#0052CC' },
    { name: 'City 1', parent: 'A', value: 5 },
    { name: 'City 2', parent: 'A', value: 3 },
  ]
}]
```

## Network Graph

Requires: `modules/networkgraph`. Force-directed layout, draggable nodes.

```js
series: [{
  type: 'networkgraph',
  layoutAlgorithm: { enableSimulation: true, friction: -0.9 },
  dataLabels: { enabled: true, linkFormat: '' },
  data: [['Node A', 'Node B'], ['Node A', 'Node C'], ['Node B', 'Node D']]
}]
```

## Organization Chart

Requires: `modules/sankey` AND `modules/organization`.

```js
series: [{
  type: 'organization',
  data: [
    { from: 'CEO', to: 'CTO' },
    { from: 'CEO', to: 'CFO' },
  ],
  nodes: [
    { id: 'CEO', title: 'CEO', name: 'Alice' },
    { id: 'CTO', title: 'CTO', name: 'Bob' },
  ],
  colorByPoint: false,
}]
```

## Waterfall

```js
series: [{
  type: 'waterfall',
  upColor: '#36b37e',
  color: '#de350b',
  data: [
    { name: 'Start', y: 120000 },
    { name: 'Revenue', y: 569000 },
    { name: 'Costs', y: -342000 },
    { name: 'Subtotal', isIntermediateSum: true },
    { name: 'Tax', y: -47000 },
    { name: 'Total', isSum: true },
  ],
}]
```

## Solid Gauge (KPI)

Requires: `modules/solid-gauge`.

```js
chart: { type: 'solidgauge' },
pane: {
  startAngle: -90, endAngle: 90,
  background: [{
    innerRadius: '60%', outerRadius: '100%',
    shape: 'arc', backgroundColor: '#eee', borderWidth: 0,
  }],
},
yAxis: { min: 0, max: 100, lineWidth: 0, tickWidth: 0 },
series: [{
  data: [73],
  dataLabels: {
    format: '<span style="font-size:2em">{y}%</span>',
    borderWidth: 0, y: -20,
  },
}]
```

## Packed Bubble

```js
chart: { type: 'packedbubble' },
plotOptions: {
  packedbubble: {
    minSize: '30%', maxSize: '120%',
    layoutAlgorithm: { splitSeries: true, gravitationalConstant: 0.02 },
    dataLabels: { enabled: true, format: '{point.name}' },
  },
},
series: [
  { name: 'Europe', data: [{ name: 'Germany', value: 767 }] },
  { name: 'Asia', data: [{ name: 'China', value: 1154 }] },
]
```

## Timeline

Requires: `modules/timeline`.

```js
series: [{
  type: 'timeline',
  data: [
    { name: 'Founded', label: '2020-01-15', description: 'Company was founded' },
    { name: 'Series A', label: '2021-06-01', description: 'Raised $10M' },
  ]
}]
```
