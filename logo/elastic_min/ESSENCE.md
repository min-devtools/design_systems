# elastic_min — tinh hoa để tìm biểu tượng

## Một câu
Bàn tra cứu Elasticsearch: ném câu query JSON vào núi dữ liệu, nhận về đúng
dòng cần tìm — kèm điểm relevance và "took 3ms".

## Bản chất (cái làm nó KHÁC Kibana)

1. **Tìm thấy, không phải "tìm kiếm"** — khoảnh khắc giá trị là *hit hiện ra*:
   một điểm sáng giữa khối dữ liệu khổng lồ. Needle in haystack, spotlight,
   một chấm nổi bật giữa đám mờ.
2. **Query là ngôn ngữ** — nói chuyện với dữ liệu bằng JSON DSL trong Monaco,
   không phải kéo-thả dashboard. Đây là workbench của dev, không phải BI tool.
3. **Cấu trúc tầng** — index → shard → document: dữ liệu xếp lớp, cắt mảnh.
   Shard (mảnh vỡ tinh thể) là khái niệm ES đẹp nhất để hình tượng hoá.
4. **Facet/aggregation** — một query đi vào, kết quả tách thành nhiều mặt
   (lăng kính: 1 tia vào → phổ tách ra).
5. **Min của family** — vẫn gene `_min`: tối giản, local, keyboard-first,
   underscore là chữ ký chung. Dark "Bearded Arc" là theme gốc của chính app này.

## Cá tính (nếu app là người)
Thủ thư kiêm thám tử. Đọc cả núi sách trong 3ms, trả về đúng một dòng,
không bình luận thừa. Chính xác đến từng token.

## Động từ trung tâm
**Tìm thấy trong tích tắc.** Không phải "trực quan hoá", không phải "giám sát".

## Biểu tượng nên đi tìm (theo tầng nghĩa)

| Tầng | Motif | Vì sao |
|---|---|---|
| Tìm thấy | chấm sáng giữa đám chấm mờ, spotlight, crosshair | khoảnh khắc hit |
| Lăng kính | prism — 1 tia vào, nhiều tia ra | query → facets/aggregations |
| Xếp lớp | layers, stack, sách nghiêng trên kệ | index, inverted index |
| Mảnh | shard, tinh thể cắt cạnh, mosaic tối giản | shards của ES |
| Terminal | `_` underscore, cursor | chữ ký family `_min` |
| Tốc độ | tia chớp mảnh, "3ms" | took-time — niềm tự hào của ES |

## Cái KHÔNG phải (tránh khi tìm reference)
- Kính lúp đứng một mình (= mọi app search trên đời)
- Logo Elastic chính chủ (cụm sóng nhiều màu) — tránh mọi biến thể
- Ống nhòm, la bàn, bản đồ; biểu đồ cột/dashboard (= Kibana)
- Đám mây, database trụ tròn cliché

## Từ khoá search (Dribbble / Pinterest / Behance / Iconfinder)
- "dot among dots logo minimal" / "standout dot mark"
- "prism logo geometric flat"
- "spotlight beam icon minimal"
- "crystal shard logo flat"
- "layers stack logo minimal"
- "negative space letter e logo"
- "search result highlight icon"
- "developer tool app icon dark minimal"

## Ràng buộc hình thức (từ design system — chung với requests_min)
- Nền tối `#1c2433` hoặc purple brand `#7a3eed`; nhấn: `#69C3FF` blue,
  `#3CEC85` green, chữ sáng `#d0d7e4`
- Phẳng, nét dày bo tròn, không gradient/không bevel
- Đọc được ở 28px — 1 ý, 1 hình, ≤2 màu + nền
- Tile macOS squircle ~22.5% radius
- Đặt cạnh icon requests_min phải nhìn ra "anh em một nhà" nhưng không nhầm nhau
