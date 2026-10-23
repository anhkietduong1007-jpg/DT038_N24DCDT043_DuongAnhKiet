# Danh mục 11 ảnh minh chứng thực thi (A01–A11) cho đề tài DT038

- **Sinh viên**: Dương Anh Kiệt
- **MSSV**: N24DCDT043
- **Lớp**: D24CQDT01-N
- **Mã đề**: DT038 — Đặt n quân hậu bằng quay lui

| Mã ảnh | Tên file ảnh | Mục tiêu & Ca kiểm tra | Lệnh thực thi & Kỳ vọng |
|---|---|---|---|
| **A01** | `01_vi_du_1.png` | Ví dụ 1 phiếu giao ($n = 4$) | `julia demo.jl`<br>Kỳ vọng: 2 nghiệm; nghiệm đầu `[2, 4, 1, 3]`; 17 nút duyệt; in bàn cờ 4x4. |
| **A02** | `02_vi_du_2.png` | Ví dụ 2 phiếu giao ($n = 3$) | `julia demo.jl`<br>Kỳ vọng: 0 nghiệm; nghiệm đầu rỗng `[]`; thông báo vô nghiệm; 6 nút. |
| **A03** | `03_tu_thiet_ke_1.png` | Ca tự thiết kế 1 ($n = 6$) | `giai_bai(6)`<br>Kỳ vọng: 4 nghiệm; nghiệm đầu `[2, 4, 6, 1, 3, 5]`; 153 nút duyệt. |
| **A04** | `04_tu_thiet_ke_2.png` | Ca tự thiết kế 2 ($n = 7$) | `giai_bai(7)`<br>Kỳ vọng: 40 nghiệm; nghiệm đầu `[1, 3, 5, 7, 2, 4, 6]`; 552 nút duyệt. |
| **A05** | `05_bien_1.png` | Biên cực tiểu ($n = 1$) | `giai_bai(1)`<br>Kỳ vọng: 1 nghiệm `[1]`; chỉ số đường chéo không bị lỗi âm hay vượt biên. |
| **A06** | `06_bien_2.png` | Ca vô nghiệm ($n = 2$) | `giai_bai(2)`<br>Kỳ vọng: 0 nghiệm; kết thúc bình thường, an toàn. |
| **A07** | `07_bien_3.png` | Biên đề bài bàn cờ chuẩn ($n = 8$) | `giai_bai(8)`<br>Kỳ vọng: 92 nghiệm; nghiệm đầu `[1, 5, 8, 6, 3, 7, 2, 4]`; 2057 nút duyệt. |
| **A08** | `08_input_khong_hop_le.png` | Validator từ chối đầu vào sai | `kiem_tra_dau_vao(0)` & `(11)` & `("abc")`<br>Kỳ vọng: Ném `ArgumentError` với thông báo rõ ràng. |
| **A09** | `09_tong_ket_kiem_thu.png` | Tổng kết chạy toàn bộ 15 test case | `julia test/runtests.jl`<br>Kỳ vọng: 53/53 phép kiểm tra đạt 100% PASS. |
| **A10** | `10_clone_sach_chay_lai.png` | Clone repo sạch tại commit C và chạy lại | `git clone ...`, kiểm tra HEAD, chạy lại demo và test thành công. |
| **A11** | `11_github_repo_commit.png` | Giao diện GitHub commit C thật | Hiển thị URL repo, commit hash C, mã nguồn trên GitHub của sinh viên. |
