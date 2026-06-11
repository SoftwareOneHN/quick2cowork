---
name: browser-automation
description: Browse the web and interact with pages programmatically — click, type, scroll, extract data, fill forms, and automate multi-step web workflows. Use when the user needs to interact with a website, scrape data, fill forms, or automate browser-based tasks.
metadata:
  author: quick2cowork
  version: "1.0"
  source: amazon-quick/browser
  migration-status: needs-evaluation
compatibility: Requires a browser automation backend (Playwright, Puppeteer, or MCP browser server).
---

# Browser Automation

Control a web browser programmatically for web interaction, data extraction, and form filling.

## Migration Notes

This skill was ported from Amazon Quick's custom browser tool (22 tools, Playwright-based, with a custom perception layer). The original features:

- **Perception layer**: DOM → numbered element list via 5-layer discovery pipeline
- **Stealth mode**: Anti-detection (webdriver hiding, plugin faking)
- **Crash recovery**: Auto-relaunch on Chrome disconnect
- **Loop detection**: Escalating warnings when stuck
- **Rich text editor support**: Specialized handling for contenteditable

For Claude Cowork, this skill requires one of:
1. An MCP browser server (e.g., `@anthropic/mcp-browser`)
2. Playwright installed locally with `computer_use` tool
3. A custom browser automation integration

## Core Workflow

1. **Navigate** to URL → get page content/elements
2. **Identify** target elements (by text, selector, or coordinates)
3. **Interact** — click, type, scroll, select
4. **Verify** — check page state changed as expected
5. **Extract** — pull data from the page

## Key Principles

### Efficiency: Read Before Acting
- Read page content/structure before clicking randomly
- Use DOM queries to find elements instead of scrolling
- Extract all data in one pass when possible

### Safety: Confirm Before Irreversible Actions
STOP and ask user before:
- Sending emails (clicking Send)
- Submitting forms (Place Order, Confirm)
- Deleting anything
- Making payments
- Publishing content

### Navigation
- Prefer same-tab navigation over opening new tabs
- Extract URLs and navigate directly rather than clicking through menus
- Verify complete URLs before navigating (no truncated links)

## Common Patterns

### Form Filling
```
1. Navigate to form page
2. Identify all input fields
3. Fill fields in order
4. Verify values entered correctly
5. STOP — ask user before submitting
```

### Data Extraction
```
1. Navigate to page
2. Read full page content (structured)
3. Extract target data (tables, lists, specific sections)
4. Format and return to user
```

### Multi-Step Workflow
```
1. Navigate to starting page
2. For each step: identify target → interact → verify state change
3. Handle auth redirects (wait for redirect to complete)
4. Extract final result
```

## Error Handling

| Error | Recovery |
|-------|----------|
| Element not found | Refresh element list, try different selector |
| Click failed | Try alternative click method (JS click) |
| Page not loading | Wait longer, check URL |
| Auth redirect | Wait for redirect to complete before interacting |
| CAPTCHA | Ask user to solve manually |
| Stuck in loop | Change strategy after 3 repeated actions |

## Anti-Patterns

- DON'T scroll to read content — extract text directly
- DON'T take screenshots to read text — use text extraction
- DON'T click through UI to find data — query the DOM
- DON'T guess coordinates — use element identification
- DON'T navigate to truncated URLs — verify first
