# quick2cowork

Bộ Agent Skills cho Claude Code / Claude Cowork, theo chuẩn [agentskills.io](https://agentskills.io).

17 skills tạo thành một hệ thống lifecycle hoàn chỉnh — từ nhận task, lên kế hoạch, thực thi song song, thu thập dữ liệu, đến xuất deliverable. Hệ thống tự cải thiện qua mỗi lần chạy.

---

## Lifecycle tổng quan

```
 ┌─────────────────────── TASK LIFECYCLE ───────────────────────┐
 │                                                               │
 │   TRIGGER          PLAN            EXECUTE         OUTPUT     │
 │                                                               │
 │  scheduled─┐    plan-mode       browser-auto    doc-generation│
 │  tasks     ├──→ deep-analysis ──→ desktop-auto ──→ doc-convert│
 │  user req──┘    parallel-orch   knowledge-graph  markdown-docs│
 │                 agent-delegation memory-mgmt     html-design  │
 │                                                  highcharts   │
 │                                                  style-clone  │
 └───────────────────────────────────────────────────────────────┘

 ┌─────────────────── SKILL LIFECYCLE (meta) ───────────────────┐
 │                                                               │
 │   skill-authoring ──→ execute ──→ skill-improvement ──→ v2   │
 │        (tạo)           (chạy)        (cải thiện)      (loop) │
 └───────────────────────────────────────────────────────────────┘

 ┌─────────────────── DATA LIFECYCLE ───────────────────────────┐
 │                                                               │
 │   collect (browser, desktop) ──→ store (knowledge-graph)     │
 │                                    ──→ recall (memory-mgmt)  │
 │                                    ──→ use (output skills)   │
 └───────────────────────────────────────────────────────────────┘
```

### Ví dụ: "Phân tích competitive landscape và xuất slide"

1. **plan-mode** — tạo plan, track tiến độ
2. **deep-analysis** — structure thành research tracks
3. **parallel-orchestration** — spawn sub-tasks nghiên cứu song song
4. **browser-automation** — scrape data từ web
5. **knowledge-graph** — tra cứu entities đã biết, lưu entities mới
6. **document-generation** — xuất PPTX presentation
7. **memory-management** — lưu insights cho lần sau
8. **skill-improvement** — nếu workflow adapt → fold learnings vào skill

---

## Cài đặt

### Cách 1: npx (nhanh nhất — khuyến nghị)

Dùng [Skills CLI](https://github.com/vercel-labs/skills) để cài từ GitHub:

```bash
# Cài TẤT CẢ skills
npx skills add SoftwareOneHN/quick2cowork

# Cài 1 skill cụ thể
npx skills add SoftwareOneHN/quick2cowork --skill document-conversion
npx skills add SoftwareOneHN/quick2cowork --skill highcharts
npx skills add SoftwareOneHN/quick2cowork --skill parallel-orchestration
```

Skills CLI tự detect agent đang dùng (Claude Code, Cursor, Copilot, Codex...) và cài đúng chỗ.

### Cách 2: Project-level (manual)

```bash
git clone https://github.com/SoftwareOneHN/quick2cowork.git
cp -r quick2cowork/ /path/to/your-project/.claude/skills/
```

Claude tự động phát hiện và load skills từ `.claude/skills/`.

### Cách 3: Personal-level (mọi project)

```bash
cp -r quick2cowork/ ~/.claude/skills/
```

### Cách 4: Chọn skill cụ thể

```bash
# Chỉ lấy những gì cần
cp -r quick2cowork/document-conversion/ ~/.claude/skills/
cp -r quick2cowork/highcharts/ ~/.claude/skills/
```

---

## Skills theo Phase trong Lifecycle

### Phase 1: Trigger & Planning

| Skill | Vai trò | Khi nào activate |
|-------|---------|-----------------|
| **scheduled-tasks** | Tự trigger tác vụ định kỳ | "monitor X", "every morning", "watch for" |
| **plan-mode** | Track tiến độ multi-step | Task có 3+ bước, chạy > vài phút |
| **deep-analysis** | Nghiên cứu sâu đa chiều | "deep dive", "investigate", "analyze thoroughly" |
| **parallel-orchestration** | Chia task song song | Nhiều files/topics xử lý cùng lúc |
| **agent-delegation** | Ủy thác cho agent khác | "use kiro", "delegate to", "ask claude code" |

### Phase 2: Execution & Data

| Skill | Vai trò | Khi nào activate |
|-------|---------|-----------------|
| **browser-automation** | Tương tác web, scrape, fill form | Cần data từ website |
| **desktop-automation** | Điều khiển app native (OCR) | App không có API |
| **knowledge-graph** | Lưu/tra cứu entities & relationships | "who is X", "how connected", "remember this" |
| **memory-management** | Quản lý bộ nhớ đã học | "show memories", "what do you remember" |

### Phase 3: Output & Delivery

| Skill | Vai trò | Khi nào activate |
|-------|---------|-----------------|
| **document-generation** | Tạo DOCX, PDF, PPTX, XLSX | "create presentation", "generate report" |
| **document-conversion** | Convert giữa các format | "convert to PDF", "Word sang HTML" |
| **markdown-documents** | Tạo docs + SVG visualization | "write report" dạng .md |
| **html-design** | Dashboard HTML, theme tokens | "create dashboard", "design widget" |
| **highcharts** | 30+ loại chart, data visualization | "vẽ chart", "biểu đồ" |
| **writing-style-clone** | Viết theo giọng văn ai đó | "write in my style", "clone tone" |

### Meta: Skill Evolution (self-improving loop)

| Skill | Vai trò | Khi nào activate |
|-------|---------|-----------------|
| **skill-authoring** | Tạo skill mới từ workflow | "save this as a skill" |
| **skill-improvement** | Cải thiện skill từ execution | Sau khi chạy skill, có adaptations |

---

## Cấu trúc thư mục

```
quick2cowork/
├── README.md
│
├── ─── PLANNING ───────────────────
├── plan-mode/
├── deep-analysis/
├── parallel-orchestration/
│   └── references/examples.md
├── scheduled-tasks/
├── agent-delegation/
│
├── ─── EXECUTION ──────────────────
├── browser-automation/
├── desktop-automation/
├── knowledge-graph/
├── memory-management/
│
├── ─── OUTPUT ─────────────────────
├── document-generation/
│   └── references/
├── document-conversion/
├── markdown-documents/
├── html-design/
├── highcharts/
│   └── references/chart-types.md
├── writing-style-clone/
│
└── ─── META ───────────────────────
    ├── skill-authoring/
    └── skill-improvement/
```

---

## Cách hoạt động

Mỗi skill là 1 thư mục chứa:

| File | Vai trò |
|------|---------|
| `SKILL.md` | **Bắt buộc** — frontmatter (name, description) + instructions |
| `references/` | Tài liệu chi tiết, load on-demand |
| `scripts/` | Code có thể chạy |
| `assets/` | Templates, resources |

**Progressive disclosure**: Claude đọc `description` (~100 tokens) để quyết định activate. Khi activate → đọc full SKILL.md body (<5000 tokens). References chỉ load khi cần thêm chi tiết.

---

## Yêu cầu hệ thống

### Python packages (cho document skills)

```bash
pip install markdown reportlab python-docx htmldocx mammoth python-pptx openpyxl xlsxwriter
```

### Highcharts

CDN (không cần install): `https://cdn.jsdelivr.net/npm/highcharts@12.1.2/`

### Platform-dependent skills

| Skill | Cần gì |
|-------|--------|
| browser-automation | MCP browser server hoặc Playwright |
| desktop-automation | computer_use tool + OCR |
| scheduled-tasks | Background scheduler / cron |
| agent-delegation | A2A protocol / multi-agent framework |

---

## Tùy chỉnh

- **Sửa description** → match trigger phrases của bạn
- **Thêm examples** → cho use case cụ thể
- **Thêm references/** → domain knowledge riêng
- **Xóa skills không dùng** → giảm context overhead
- **Combine skills** → merge 2 skills thành 1 nếu luôn dùng chung

---

## Readiness Matrix

| Tier | Skills | Status |
|------|--------|--------|
| ✅ Production-Ready | document-conversion, highcharts, html-design, markdown-documents, writing-style-clone, skill-authoring, skill-improvement, document-generation | Dùng ngay |
| 🔧 Needs Runtime | parallel-orchestration, deep-analysis, plan-mode, knowledge-graph, memory-management | Cần sub-task / storage backend |
| ⚠️ Needs Platform | browser-automation, desktop-automation, scheduled-tasks, agent-delegation | Cần MCP server / native access |

---

## License

MIT — tự do sử dụng, sửa đổi, phân phối.

## Nguồn gốc

Migrated từ Amazon Quick (desktop AI companion).
Format: [agentskills.io specification](https://agentskills.io/specification).
Ngày: 2026-06-11.
