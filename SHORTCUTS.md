# Keyboard shortcuts — canon

Shared across `requests_min`, `kafka_ui_min`, `redis_min`, `elastic_min`, `log_min`.
`⌘` on macOS, `Ctrl` elsewhere — every handler reads `e.metaKey || e.ctrlKey`.

## Item actions

The "item" is whatever the sidebar highlights in that app: a **request**
(requests_min), a **source** (log_min), a **connection** (kafka / redis / elastic).
Same three keys everywhere.

| Key | Action | Notes |
|---|---|---|
| `⌘E` | Rename / edit the selected item | Prompt dialog, or opens the item's editor tab |
| `⌘D` | Duplicate the selected item | New item named `<name> copy`, opened |
| `⌘⌫` | Delete the selected item | **Always** a confirm dialog, `danger: true` |

Rules:

- **Never bind bare `Backspace` / `Delete`.** Too easy to hit with the sidebar
  focused; one keystroke must not destroy user data.
- Delete always routes through `openDialog({ kind: "confirm", danger: true })`.
  `Enter` confirms, `Esc` cancels — the Dialog component binds both.
- The handler is a global `window`/`document` keydown listener, not a per-node
  `onKeyDown`: WebKit in the Tauri webview does not focus rows on click.
- Bail out when an input is focused (`INPUT` / `TEXTAREA` / `isContentEditable` /
  `.monaco-editor`) and when a dialog is open.

## Global

| Key | Action |
|---|---|
| `⌘K` | Command palette |
| `⌘N` | New item (request / source / key / query / topic messages) |
| `⌘↵` | Run / send / reload the active tab |
| `⌘S` | Save the active tab (where saving is a distinct step) |
| `⌘B` | Toggle left sidebar |
| `⌘R` | Toggle right inspector |
| `⌘,` | Settings tab |
| `⌘W` | Close active tab |
| `⌘1`…`⌘9` | Jump to Nth tab |
| `⌘+` / `⌘-` | UI font size ±0.5px |
| `Esc` | Close palette / dialog / inline search |

Inside the command palette, `Tab` and `↓` select the next result, while `↑`
selects the previous result. With Vim mode/keys enabled, `Ctrl-N` and `Ctrl-P`
also select the next and previous result respectively.

`⌘E` and `⌘D` are **reserved for item actions** and must not be taken by an
app-specific view. Per-app view shortcuts use `⌘⇧<letter>` or a free letter:

| App | View | Key |
|---|---|---|
| kafka_ui_min | Browse topics | `⌘T` |
| kafka_ui_min | Consumer groups | `⌘G` |
| redis_min | Browse keys | `⌘T` |
| redis_min | Console | `⌘⇧C` |
| redis_min | Server info | `⌘I` |
| redis_min | Pub/Sub | `⌘U` |
| elastic_min | Documents | `⌘⇧D` |

## Dialogs

One `Dialog.tsx` shape in every app:

- Key handler on `document` in the **capture** phase with `stopPropagation()`, so
  an open dialog swallows `Enter`/`Esc` before global shortcuts see them.
- `Enter` submits (prompt: only when the value is non-empty), `Esc` cancels.
- Confirm dialogs focus the confirm button on open; `role="dialog"`,
  `aria-modal="true"`, `aria-label={title}`.
- Clicking the backdrop cancels.

## Buttons

`ToolButton` variants — the rule that decides the colour:

| Variant | Use |
|---|---|
| `primary` | The **one** commit action of a form, card, or dialog footer: Save, Apply, Create, Connect, Send, Run |
| `danger` | Destructive commit: Delete, Remove, Reset, Disconnect, Cancel a running operation |
| `default` | Everything else: Cancel, Test connection, secondary navigation, steppers, toolbar icons |

- **Exactly one `primary` per button group.** Two primaries in one footer means
  one of them is really `default` (e.g. log_min's `Save` next to `Save & Run`).
- Icon-only toolbar buttons stay `default` unless they are the group's run/send
  action or destructive.
