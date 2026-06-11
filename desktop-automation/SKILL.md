---
name: desktop-automation
description: Control the desktop with mouse, keyboard, and screen analysis via OCR. Use when the user needs to interact with native desktop applications that have no API or dedicated integration — clicking buttons, typing text, reading screen content.
metadata:
  author: quick2cowork
  version: "1.0"
  source: amazon-quick/computer_use
  migration-status: needs-evaluation
compatibility: Requires desktop access with OCR capability (e.g., computer_use tool, Tesseract, or similar).
---

# Desktop Automation

Control native desktop applications via screen capture, OCR, and simulated input.

## Migration Notes

This skill requires native desktop access. For Claude Cowork, evaluate:
1. Does the target environment support `computer_use` tool?
2. Is there an MCP server for desktop automation?
3. Is Tesseract/OCR available in the runtime?

## Core Workflow

1. **Analyze screen** — capture screenshot + OCR to get element coordinates
2. **Click** at coordinates from OCR results
3. **Type** text into focused fields
4. **Verify** — analyze screen again to confirm action worked

## Available Actions

| Action | Purpose |
|--------|---------|
| `analyze_screen` | Screenshot + OCR → text with coordinates |
| `click` | Click at (x, y) coordinates |
| `type` | Type text string |
| `key_press` | Press key with modifiers |
| `hotkey` | Key combo ("cmd+s", "ctrl+c") |
| `scroll` | Scroll at position |
| `open_app` | Launch application |
| `drag` | Click and drag between points |

## Best Practices

- Always analyze screen FIRST — don't guess coordinates
- Use OCR center_x/center_y values for clicking
- Verify after every action (re-analyze screen)
- Lower OCR confidence threshold for small/low-contrast text
- Prefer dedicated integrations over desktop automation when available

## When NOT to Use

- Web interaction → use browser automation skill instead
- File operations → use file system tools directly
- API-accessible apps → use the API/integration
- This is last resort for apps with no programmatic interface
