# Components

Class-based CSS primitives from `layout.css` + `components.css`. No framework
required — plain classes. All sizes/colors below are the real shipped values.

---

## App shell (`layout.css`)

```html
<div class="app-frame">              <!-- grid rows: 42px 1fr 28px -->
  <div class="titlebar">
    <div class="traffic">…</div>     <!-- macOS traffic-light spacer, 84px left pad -->
    <div class="search">…</div>      <!-- centered ⌘K bar -->
    <div class="toolbar">…</div>     <!-- right-aligned tools -->
  </div>
  <main class="main">                <!-- grid: left-w | 1fr | right-w -->
    <aside class="sidebar">…</aside>
    <section class="workspace">      <!-- grid rows: 42px 1fr -->
      <nav class="tabs">…</nav>
      <div class="content">…</div>
    </section>
    <aside class="inspector">…</aside>
  </main>
  <div class="statusbar">…</div>     <!-- 28px, mono, 3-col grid -->
</div>
```

**Body state classes** (toggle on `<body>`):

| Class | Effect |
|-------|--------|
| `.light` | Light theme |
| `data-theme="…"` | One of 27 palettes |
| `.left-collapsed` | Collapse sidebar to 48px icon rail |
| `.right-collapsed` | Hide inspector |
| `.inspector-unavailable` | Hide + dim the inspector toggle |
| `.compact` | Tighter: 230/300px panes, 28px rows |
| `.resizing` / `.resizing-y` | Active drag (col/row cursor) |

**Resize handles:** `.resize-handle.vertical.left` / `.right` — invisible until
hover, then a `var(--blue)` bar with a glow (`box-shadow`) fades in.

---

## Tabs (the signature element)

```html
<nav class="tabs">
  <button class="tab active">
    <span class="tab-dirty-dot"></span>        <!-- orange, unsaved -->
    <span class="tab-method method-tag POST">POST</span>
    <span class="tab-title">Create order</span>
    <span class="tab-close">×</span>
  </button>
  <button class="tab">…</button>
  <button class="tab-add"><!--+ icon-->Request</button>
</nav>
```

- `.tab` — 31px tall, `10px 10px 0 0` radius, min 96 / max 190px, draggable.
- `.tab.active` — blue top-gradient wash + colored border + hairline top
  highlight, bottom border transparent (fuses into content).
- `.tab.dragging` (0.4 opacity) / `.tab.drag-over` (blue insertion bar `::before`).
- `.tab-dirty-dot` — 7px orange dot for unsaved edits.
- `.tab-close` — 17px, appears as a rounded hover target.
- `.tab-title-input` — inline rename field (double-click a tab).
- `.tab-add` — dashed-border "new" button, blue tint on hover.

**Secondary tabs** — `.mini-tabs` (inside panels/inspector): 26px pill buttons,
active gets `--pane-2` fill + border.

---

## Buttons

```html
<button class="tool-btn">Run</button>
<button class="tool-btn icon-only"><!--icon--></button>
<button class="tool-btn primary">Send</button>
<button class="tool-btn danger">Delete</button>
<button class="tool-btn panel-toggle active"><!--icon--></button>
<button class="action-btn">Open in tab</button>
```

- `.tool-btn` — 28px, 8px radius, 1px border, transparent → `--pane-3` on hover.
- `.icon-only` — square 28×28.
- `.primary` — `--accent-secondary` fill, `--text-on-accent` text, soft glow.
  In light mode: solid `#7A3EED` with white text.
- `.danger` — red text.
- `.panel-toggle` — 32px square sidebar/inspector toggle; `.active` = blue tint.
  Add `.panel-corner.left/.right` for the frosted floating corner variant.
- `.action-btn` — full-width, left-aligned, `--pane-2` fill (used in panels).

---

## Form elements

| Class | What |
|-------|------|
| `.search` | 28px ⌘K bar, centered, holds a `<kbd>` |
| `.side-search` | 30px sidebar filter input |
| `.method-select` | 32px mono `<select>`; `.method-get/-post/-put/-patch/-delete/-head` color the text |
| `.query-path-input` | 32px mono URL/path input |
| `.path-input` | 26px small mono input |
| `.page-size` | 24px compact mono select |
| `.form-row` | `136px 1fr` label+input grid; focus = blue border + 3px ring |
| `.check-row` | `18px 1fr auto` checkbox row, bordered |
| `.combobox` + `.combobox-list` / `-item` / `-value` / `-hint` | Autocomplete dropdown on glass |
| `select` (bare) | Every native `<select>` normalized to a combobox-style trigger: OS chevron replaced with a themed chevron; keeps native popup + a11y |
| `.env-input` + `.env-input-token` / `-overlay` / `-suggestions` | Input that renders `{{env}}` vars as purple pills |
| `.row-check` | 15px checkbox, `accent-color: var(--blue)` |

```html
<div class="form-row">
  <label>Connection</label>
  <input type="text" value="localhost:9200" />
</div>
```

---

## Badges, pills, chips, dots

| Class | Look |
|-------|------|
| `.badge` | Mono pill, `--pane-3`. Modifiers `.green` `.yellow` `.red` `.idle` |
| `.type-pill` | 20px bordered mono chip (a field type) |
| `.field-chip` | 20px blue-tinted mono chip |
| `.path-chip` | 24px removable blue-tint JSON-path pill |
| `.health-pill` | 21px status pill: `.green` `.orange`/`.yellow` `.red` |
| `.sync-status` + `.sync-badge.synced/.dirty` | Git-sync pill in the statusbar |
| `.status-dot` | 7px dot + glow ring: `.orange` `.red` `.idle` `.purple` |
| `.index-dot` | 8px health dot: `.hot` (orange) `.red` |
| `.kbd`, `.search kbd` | Mono keyboard-shortcut pill |
| `.method-tag.GET/.POST/.WS/.RPC` | Colored HTTP-method label (used in tabs) |

---

## Navigation (sidebar)

```html
<div class="group">
  <div class="group-title">Collections <span class="badge">12</span></div>
  <div class="nav-item active"><!--icon--><span>Query</span><span class="badge">3</span></div>
</div>
```

- `.nav-item` / `.index-item` — `18px 1fr auto` grid rows, 30px min-height,
  active = blue tint + inset ring.
- `.group` + `.group-title` — uppercase muted section header.
- `.collapsible-group` + `.group-toggle` — chevron rotates `-90deg` when
  `.collapsed`.
- `.collection-tree` / `.collection-node` / `.collection-requests` /
  `.request-node` — nested collapsible file tree; `.drop-target` shows a dashed
  accent outline, `.selected` shows an inset accent bar.

---

## Tables

Dense, sticky-header, alternating rows, tabular numerics.

```html
<table>
  <thead><tr><th>ID</th><th>Email</th><th>State</th><th>Total</th></tr></thead>
  <tbody>
    <tr class="selected">
      <td class="cell-id">#1001</td>
      <td class="cell-email">a@b.com</td>
      <td class="cell-state">shipped</td>
      <td class="cell-money">$120</td>
    </tr>
  </tbody>
</table>
```

- `th` sticky, `--pane` bg; rows alternate `--row` / `--row-alt`; hover/selected
  = blue tint. `td` height 32px (28px in `.compact`).
- Semantic cell colors: `.cell-id`/`.cell-sku` (purple mono), `.cell-email`
  (blue), `.cell-money` (green), `.cell-state`/`.cell-country` (orange),
  `.cell-number` (blue-2), `.cell-date` (muted mono), `.cell-keyword` (text).
  Same set exists as `.path-value.email/.money/.state/…`.
- Long values clamp at 240px with ellipsis; `.field-highlight-line` marks a
  clicked field.

---

## Panels & cards

| Class | What |
|-------|------|
| `.panel` | Bordered card, 10px radius, `--pane` |
| `.panel h3` (in `.inspector`) | Uppercase title with a 3px accent bar `::before` |
| `.metric` + `.label` / `.value` | Stat card (21px bold value) |
| `.path-card` | Field-metadata card (`<strong>` + blue `<code>`) |
| `.kv` | `88px 1fr` key/value row with mono value |
| `.health-line` + `.bar` | Labeled progress bar (green fill) |
| `.mini-tabs` | In-panel tab strip |

---

## JSON tree

```html
<pre class="json-tree">{
  <span class="syntax-key">"took"</span>: <span class="syntax-number">12</span>,
  <span class="syntax-key">"ok"</span>: <span class="syntax-bool">true</span>,
  <span class="syntax-key">"note"</span>: <span class="syntax-null">null</span>
}</pre>
```

Spans: `.syntax-key` `.syntax-string` `.syntax-number` `.syntax-bool`
`.syntax-null` (italic) `.syntax-punc`/`.syntax-colon`. Mono, 1.75 line-height,
text-selectable. Same classes work in `.quick-query-code`.

**JSON editor chrome** (Monaco wrapper, shared by both apps):
`.json-editor-shell` + `.json-editor-tools` — a 32px strip with a valid/invalid
status word (`.valid` green / `.invalid` red) and Format / Minify / Validate
buttons.

---

## Overlays (all on frosted glass)

```html
<!-- Command palette (⌘K) -->
<div class="command">
  <div class="palette">
    <input placeholder="Type a command…" />
    <div class="cmd-list">
      <div class="cmd active"><!--icon--><span>New request</span><kbd>⌘N</kbd></div>
    </div>
  </div>
</div>

<!-- Confirm / prompt dialog -->
<div class="modal">
  <div class="prompt-dialog">
    <p class="prompt-dialog-msg">Delete "Create order"?</p>
    <div class="prompt-dialog-foot">
      <button class="tool-btn">Cancel</button>
      <button class="tool-btn danger">Delete</button>
    </div>
  </div>
</div>

<!-- Context menu -->
<div class="index-context-menu">
  <button class="context-item"><!--icon--><strong>Open</strong><kbd>↵</kbd></button>
  <button class="context-item danger"><!--icon-->Delete<kbd>⌘⌫</kbd></button>
</div>

<!-- Toast -->
<div class="toast"><!--icon--><div class="toast-body">Request saved</div></div>
```

- `.command` / `.palette` — centered, 720px max, 14px radius, blur(28px).
- `.modal` / `.prompt-dialog` — centered 420px card.
- `.index-context-menu` / `.context-item` (`.danger` variant) — floating menu.
- `.toast` — bottom-right, slides in (`@keyframes in`).
- `.diff` + `.diff-head`/`-body`/`-foot`/`-code`, with `.added`/`.removed`
  inline highlights — side-by-side diff modal.

---

## AI chat

`.ai-chat` → `.ai-messages` → `.ai-msg` (`.user` / `.error`) → `.ai-bubble`;
`.ai-hint` (empty-state), `.ai-thinking` (italic), `.ai-query` (code block),
`.ai-input-row` + `.ai-input` (autogrow textarea). User bubbles = blue tint,
right-aligned.

---

## Progress & feedback

- `.req-progress.on` — 2px indeterminate loading bar (`@keyframes run`), pinned under a request/editor header. Header container needs `position: relative`.
- `.response.loading .response-body` — dim + lock while in flight.
- `.loading-bar(.on)` — unified 2px bar (indeterminate; `.determinate` + `--progress` for 0..1). Parent must be positioned. Use for app-level / header progress.
- `.section-veil(.on)` + `.veil-spinner` — **canonical section loading state, every app**: absolutely-positioned dim + blur overlay with spinner + label, covering the busy section (table, response body, detail pane, graph). Parent must be `position: relative`. Fades in/out (160ms), blocks clicks only while `.on`. Markup: `<div class="section-veil on"><span class="veil-spinner"></span><span>Loading…</span></div>`. Show it when a section has no data yet or a blocking reload is running; do NOT flash it for sub-200ms background refetches.
- `.empty-note` — centered muted empty state.
- `.err-note` — red mono error block, wraps, selectable.

## Settings view (canonical across apps)

`.settings-view` → `.settings-shell` (720px centered column) → `.settings-header` + `.settings-card`s + `.settings-credit`.

| Class | Look |
|-------|------|
| `.settings-card` | Bordered 12px-radius card, `<h3>` title with divider |
| `.settings-row` | `30px 1fr max-content` grid: icon / copy / control |
| `.settings-icon` | 30px bordered icon tile, blue glyph |
| `.settings-copy` | `<strong>` title + muted description |
| `.settings-select` | 28px select/input, blue focus ring |
| `.switch` | 38×22 toggle (checkbox inside `<label class="switch">` + empty `<span>`) — use for booleans, not `.row-check` |
| `.shortcut-grid` / `.shortcut-row` | 2-col shortcut list, label left, `.kbd` right |

Canonical Appearance card order: Theme → Interface font size (ToolButton `− / Npx / +` stepper; clicking the value resets) → Interface font family → Editor font family → Compact density → Vim mode. App-specific cards (AI provider, GitHub, Data) follow after.

## Utility

- `.soft-blue` `.soft-green` `.soft-orange` `.soft-red` — text-color helpers.
- `.risk-low` (green) `.risk-mid` (orange) `.risk-high` (red).
- `.seg` — inline grouped segment.
