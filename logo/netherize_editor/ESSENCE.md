# netherize_editor — ESSENCE

## Tinh tuý một câu
**Một IDE bạn lái hoàn toàn bằng bàn phím.** Cùng hạng VSCode/Zed — môi trường lập trình đầy đủ, nhưng tay không rời home row.

## Động từ trung tâm
`gõ` → `nhảy tới` → `sửa`. Không rê chuột, không tìm nút. Mọi hành động là một phím hoặc một chuỗi phím.

## Cái gì thật sự quan trọng
- **Là IDE, không phải editor đồ chơi** — LSP, tree-sitter 17 ngôn ngữ, terminal, test runner, live grep, debugger-adjacent. Logo phải đứng ngang hàng VSCode/Zed, không phải đứng cạnh một text editor.
- **Keyboard-first là bản sắc**, không phải tính năng. Vim modes, which-key, leader chord, command palette, leap.
- **Block caret đặc, không nhấp nháy** — dấu hiệu nhận diện của modal editor. Luôn thấy mình đang ở đâu.
- **Workbench** — explorer + editor + terminal + statusbar. Hình dáng này ai làm nghề cũng đọc ra trong 100ms.
- GPU/wgpu, NetherCanvas, Code Graph HUD: mạnh, nhưng là chiều sâu — không phải thứ để nhét vào 28px.

## Ngôn ngữ hình
- **Khung workbench** — sidebar hẹp + editor rộng + statusbar. Nói "môi trường lập trình" ngay, cùng ngôn ngữ với hạng app nó cạnh tranh.
- **Block caret xanh trong buffer** — điểm payoff, và là thứ tách nó khỏi mọi IDE khác: caret khối = modal, keyboard-first.
- **Hình chữ nhật bo góc** — mọi app khác trong family kể chuyện bằng **chấm tròn**; netherize là app duy nhất dùng khối/pane. Nhận ra ngay ở 28px, không lẫn.
- Sidebar `#31456b` lùi sau, editor `#3a4f75` là sân khấu, caret `#3CEC85` là chỗ bạn đang đứng.

## Tránh
- **Chơi chữ với cái tên.** `netherize` → nether portal → cổng Minecraft: nghe thì thông minh, nhưng nói về cái tên chứ không nói về sản phẩm. Đã thử cả một batch (`xA-portal`), sai hướng.
- Con trỏ nhấp nháy hình que, dấu `<>`, dấu ngoặc nhọn — cliché editor.
- Terminal prompt `$`/`>` — đó là log_min.
- Chấm tròn trên đường thẳng — ngôn ngữ của phần còn lại trong family.
- Gradient, glow, hiệu ứng "GPU" — sai palette, và không nói được điều gì.
- Bàn phím vẽ đầy đủ (nhiều phím) — thành mớ nhiễu ở 28px.

## Palette (bắt buộc)
tile `#1c2433` · sidebar/lùi `#31456b` · editor/cấu trúc `#3a4f75` · payoff `#3CEC85`

## Variants

**Batch y — keyboard-first IDE (đúng hướng):**
| tên | ý |
|---|---|
| `yD-workbench` | explorer + editor + statusbar, block caret xanh trong buffer — **chọn** |
| `yA-keycap-n` | keycap + monogram N, nét chéo xanh = command path (giữ hướng logo cũ, kéo về palette family) |
| `yE-keycap-lit` | keycap xanh đang nhấn, caret khoét thủng mặt phím |
| `yC-chord` | hai phím, phím thứ hai xanh = phím hoàn tất lệnh |
| `yB-keycap-caret` | keycap có legend là block caret |

**Batch x/w — cổng portal (bỏ):** chơi chữ với tên, không nói về sản phẩm.
`xA-portal` `xA2-portal-caret` `xA3-portal-through` `xB-caret` `wA-portal` `wA2-portal-focal`
Ghi lại một bài học hình khối nếu sau này cần khung dựng bằng block: cổng vuông + khối nhỏ đều 4 cạnh **đọc ra con chip CPU**; muốn ra cổng phải tỉ lệ cao ~1:1.8 và chỉ chia khối ở hai trụ dọc.

**Batch w khác (bỏ):** `wB-caret` pane rỗng → giống cục pin. `wC-atlas` glyph atlas → giống bàn phím. `wD-scope` khối lồng lệch → giống bóng đổ lỗi. `wE-focus` chia vùng → giống icon dashboard.

**Batch v (bỏ):** một ý tưởng "card xếp trên mặt phẳng" mặc sáu bộ đồ.
`vA-canvas` `vB-focal` `vC-panes` `vD-depth` `vE-zoom` `vF-scatter`
