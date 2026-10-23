# DT038 — ĐẶT N QUÂN HẬU BẰNG QUAY LUI CẮT NHÁNH

## Thông tin sinh viên và đề tài

- **Họ và tên**: Dương Anh Kiệt
- **Mã số sinh viên (MSSV)**: N24DCDT043
- **Lớp**: D24CQDT01-N
- **Môn học**: Cấu trúc dữ liệu và giải thuật (INT13185 — Nhóm 03)
- **Giảng viên hướng dẫn**: ThS. Hồ Nhựt Minh
- **Mã đề tài**: `DT038`
- **Tên đề tài**: Đặt n quân hậu bằng quay lui (N-Queens with Backtracking & Branch Pruning)
- **Giáo trình tham khảo**: `Giao-trinh-Cau-truc-du-lieu-va-Giai-thuat-INT1306.pdf`, Chương 3, mục 3.4.3 *Bài toán n quân hậu*; mục 3.4.4 *Hiệu quả của việc cắt nhánh*; Bài 3.2; trang in 73–75; trang PDF 85–87.

---

## Hợp đồng Dữ liệu (Input / Output Contract)

### 1. Đầu vào (Input)
- Kích thước bàn cờ $n$: Số nguyên ($1 \le n \le 10$).
- Dữ liệu được truyền trực tiếp qua hàm `giai_bai(n)` hoặc nhập từ bàn phím qua `demo.jl`.
- **Ràng buộc & Kiểm thực (Validator)**:
  - Nếu $n \notin \mathbb{Z}$ (số thực, chuỗi, `nothing`): Ném `ArgumentError`.
  - Nếu $n < 1$: Ném `ArgumentError` ("Kích thước bàn cờ n phải >= 1").
  - Nếu $n > 10$: Ném `ArgumentError` ("Kích thước bàn cờ n phải <= 10").

### 2. Đầu ra (Output)
Trả về đối tượng `KetQuaNQueens` gồm các trường:
- `n::Int`: Kích thước bàn cờ.
- `so_nghiem::Int`: Tổng số cách đặt $n$ quân hậu hợp lệ.
- `nghiem_dau::Vector{Int}`: Mảng $n$ phần tử, với $x[i]$ là vị trí cột của quân hậu tại hàng $i$ ($1 \le x[i] \le n$). Nếu vô nghiệm, trả về mảng rỗng `Int[]`.
- `tat_ca_nghiem::Vector{Vector{Int}}`: Danh sách toàn bộ các nghiệm tìm được theo thứ tự duyệt cột tăng dần.
- `so_nut_goi::Int`: Số nút trên cây không gian trạng thái đã ghé thăm (số lần gọi hàm đệ quy `dat_hau!`).
- `so_lan_thu_cot::Int`: Tổng số lần thử đặt hậu vào một cột.
- `so_nhanh_cat::Int`: Số lần nhánh bị cắt tỉa do phát hiện xung đột.

---

## Cấu trúc mã nguồn

```
DT038_N24DCDT043_DuongAnhKiet/
├── src/
│   └── DeTai.jl              # Cài đặt thuật toán quay lui, 3 mảng đánh dấu, validator, in bàn cờ
├── test/
│   └── runtests.jl           # Bộ kiểm thử 53 phép kiểm (15 test case) đạt 100%
├── docs/
│   └── anh_ket_qua/
│       ├── README.md         # Kế hoạch và danh mục 11 ảnh minh chứng A01–A11
│       └── *.png             # Các ảnh chụp thực thi thật
├── demo.jl                   # Kịch bản chạy minh họa 2 ví dụ và khảo sát hiệu quả cắt nhánh
├── README.md                 # Hướng dẫn chi tiết
└── .gitignore                # Bỏ qua tệp rác, cache, build tạm
```

---

## Hướng dẫn cài đặt và thực thi

Yêu cầu môi trường: **Julia 1.10+** (đã kiểm nghiệm chuẩn xác trên Julia 1.12.7).

Mở terminal PowerShell tại thư mục bài làm:

```powershell
# 1. Kiểm tra phiên bản Julia
julia --version

# 2. Chạy chương trình minh họa (Demo)
julia --startup-file=no demo.jl

# 3. Chạy toàn bộ bộ kiểm thử tự động (Unit Tests)
julia --startup-file=no test/runtests.jl
```

---

## Kết quả kiểm thử tự động

Bộ kiểm thử tại `test/runtests.jl` gồm **5 nhóm ca kiểm thử** với tổng cộng **53 phép kiểm tra (`@test`)**, đạt **100% PASS**:

1. **Nhóm 1 (Hai ví dụ phiếu giao)**:
   - $n = 4$: Tìm được đúng 2 nghiệm; nghiệm đầu `[2, 4, 1, 3]`; nghiệm thứ hai `[3, 1, 4, 2]`.
   - $n = 3$: Vô nghiệm (`so_nghiem = 0`, `nghiem_dau = []`).
2. **Nhóm 2 (5 ca kiểm tra bắt buộc của đề bài)**:
   - $n = 1$: 1 nghiệm `[1]`, chỉ số đường chéo không bị lỗi.
   - $n = 2$: 0 nghiệm, kết thúc bình thường.
   - $n = 4$: 2 nghiệm.
   - $n = 5$: 10 nghiệm (không bị gộp do đối xứng).
   - $n = 8$: 92 nghiệm chuẩn, tất cả đều vượt qua hàm kiểm tra độc lập từng cặp hậu.
3. **Nhóm 3 (Kích thước mở rộng & biên trên)**:
   - $n = 6$: 4 nghiệm, nghiệm đầu `[2, 4, 6, 1, 3, 5]`.
   - $n = 7$: 40 nghiệm, nghiệm đầu `[1, 3, 5, 7, 2, 4, 6]`.
   - $n = 10$: 724 nghiệm.
4. **Nhóm 4 (Hợp đồng dữ liệu & Validator)**:
   - Từ chối $n \le 0$ ($n = 0, n = -5$).
   - Từ chối $n > 10$ ($n = 11, n = 15$).
   - Từ chối kiểu không phải số nguyên ($4.5, "8", nothing$).
5. **Nhóm 5 (Bất biến giải thuật & Hiệu quả cắt nhánh)**:
   - Hàm `kiem_tra_hau` độc lập phát hiện đúng các trường hợp xung đột cột, chéo xuôi, chéo ngược.
   - Số nút quay lui khớp chính xác 100% với Bảng 3.4 trang in 75 giáo trình:
     - $n = 4$: 17 nút (so với 24 hoán vị)
     - $n = 5$: 54 nút (so với 120 hoán vị)
     - $n = 6$: 153 nút (so với 720 hoán vị)
     - $n = 8$: 2057 nút (so với 40320 hoán vị)

---

## Khảo sát hiệu quả cắt nhánh

| $n$ | Số lời giải | Số nút quay lui | $n!$ (Vét cạn) | Tỉ lệ tiết kiệm |
|:---:|:---:|:---:|:---:|:---:|
| 4 | 2 | 17 | 24 | 1.4 lần |
| 5 | 10 | 54 | 120 | 2.2 lần |
| 6 | 4 | 153 | 720 | 4.7 lần |
| 7 | 40 | 552 | 5040 | 9.1 lần |
| 8 | 92 | 2057 | 40320 | 19.6 lần |

**Nhận xét**: Phương pháp quay lui với 3 mảng đánh dấu cắt bỏ ngay các nhánh vi phạm ràng buộc tại từng hàng, giúp cây trạng thái chỉ duyệt 2057 nút ở $n=8$ thay vì phải sinh đầy đủ 40320 hoán vị (tiết kiệm gần 20 lần).
