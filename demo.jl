"""
    demo.jl

Chương trình minh họa kết quả giải bài toán N quân hậu bằng quay lui (DT038).
Sinh viên: Dương Anh Kiệt — MSSV: N24DCDT043 — Lớp: D24CQDT01-N
Giảng viên hướng dẫn: Hồ Nhựt Minh (INT13185 - Nhóm 03)
"""

include(joinpath(@__DIR__, "src", "DeTai.jl"))
using .DeTai

function chay_minh_hoa()
    println("="^75)
    println("     BÀI TẬP ĐỀ TÀI CÁ NHÂN: CẤU TRÚC DỮ LIỆU VÀ GIẢI THUẬT (INT13185)")
    println("     ĐỀ TÀI DT038: ĐẶT N QUÂN HẬU BẰNG QUAY LUI CẮT NHÁNH")
    println("     Sinh viên: Dương Anh Kiệt | MSSV: N24DCDT043 | Lớp: D24CQDT01-N")
    println("="^75)
    println()

    # -------------------------------------------------------------
    # 1. MINH HỌA VÍ DỤ 1 THEO PHIẾU ĐỀ TÀI (n = 4)
    # -------------------------------------------------------------
    println(">>> [1] CHẠY VÍ DỤ 1 (n = 4):")
    println("Dữ liệu vào: n = 4")
    kq1 = giai_bai(4)
    println("Kết quả thực tế:")
    println("  - Số nghiệm tìm được : $(kq1.so_nghiem)")
    println("  - Nghiệm đầu tiên    : $(kq1.nghiem_dau)")
    println("  - Tất cả các nghiệm  : $(kq1.tat_ca_nghiem)")
    println("  - Số nút cây đã duyệt: $(kq1.so_nut_goi)")
    println("  - Số lần thử cột     : $(kq1.so_lan_thu_cot)")
    println("  - Số nhánh bị cắt    : $(kq1.so_nhanh_cat)")
    println("  - Kiểm tra độc lập   : $(kiem_tra_hau(kq1.nghiem_dau) ? "HỢP LỆ (PASS)" : "LỖI")")
    println("Minh họa bàn cờ của nghiệm đầu tiên $(kq1.nghiem_dau):")
    in_ban_co(kq1.nghiem_dau)
    println()

    # -------------------------------------------------------------
    # 2. MINH HỌA VÍ DỤ 2 THEO PHIẾU ĐỀ TÀI (n = 3)
    # -------------------------------------------------------------
    println(">>> [2] CHẠY VÍ DỤ 2 (n = 3):")
    println("Dữ liệu vào: n = 3")
    kq2 = giai_bai(3)
    println("Kết quả thực tế:")
    println("  - Số nghiệm tìm được : $(kq2.so_nghiem)")
    println("  - Nghiệm đầu tiên    : $(kq2.nghiem_dau)")
    println("  - Thông báo          : Không thể đặt 3 quân hậu mà không tấn công nhau.")
    println("  - Số nút cây đã duyệt: $(kq2.so_nut_goi)")
    println("  - Số nhánh bị cắt    : $(kq2.so_nhanh_cat)")
    in_ban_co(kq2.nghiem_dau)
    println()

    # -------------------------------------------------------------
    # 3. ĐỐI CHIẾU VỚI BẢNG 3.4 GIÁO TRÌNH (Hiệu quả cắt nhánh)
    # -------------------------------------------------------------
    println(">>> [3] BẢNG KHẢO SÁT HIỆU QUẢ CẮT NHÁNH (ĐỐI CHIẾU BẢNG 3.4 GIÁO TRÌNH):")
    println("-----------------------------------------------------------------------------")
    println("  n | Số lời giải | Số nút quay lui |   n! (Vét cạn) | Tỉ lệ tiết kiệm ")
    println("-----------------------------------------------------------------------------")
    for n_val in [4, 5, 6, 7, 8]
        kq = giai_bai(n_val)
        gt = factorial(n_val)
        ti_le = round(gt / kq.so_nut_goi, digits=1)
        println(lpad(n_val, 3), " | ",
                lpad(kq.so_nghiem, 11), " | ",
                lpad(kq.so_nut_goi, 15), " | ",
                lpad(gt, 14), " | ",
                lpad("$(ti_le) lần", 15))
    end
    println("-----------------------------------------------------------------------------")
    println("Nhận xét: Lợi ích của việc cắt nhánh tăng vượt bậc theo kích thước n.")
    println("Ở n = 8, quay lui chỉ cần duyệt 2057 nút thay vì 40320 hoán vị (tiết kiệm gần 20 lần).")
    println()

    # -------------------------------------------------------------
    # 4. CHẾ ĐỘ NHẬP TỪ BÀN PHÍM (NẾU CHẠY TƯƠNG TÁC)
    # -------------------------------------------------------------
    if isinteractive() || length(ARGS) > 0 || (stdin isa Base.TTY && !isdefined(Main, :CHAY_TU_DONG))
        print("Bạn có muốn nhập giá trị n mới từ bàn phím không? (y/n): ")
        ans = readline()
        if lowercase(strip(ans)) in ["y", "yes", "co", "c"]
            print("Nhập kích thước n (1 <= n <= 10): ")
            str_n = readline()
            try
                n_nhap = parse(Int, strip(str_n))
                kq_nhap = giai_bai(n_nhap)
                println("\nKẾT QUẢ CHO n = $n_nhap:")
                println("  - Số nghiệm       : $(kq_nhap.so_nghiem)")
                println("  - Nghiệm đầu      : $(kq_nhap.nghiem_dau)")
                println("  - Số nút duyệt    : $(kq_nhap.so_nut_goi)")
                in_ban_co(kq_nhap.nghiem_dau)
            catch e
                println("Lỗi nhập liệu: ", e)
            end
        end
    end
    println("\nHoàn tất chương trình minh họa!")
end

# Tự động thực thi khi chạy tệp
chay_minh_hoa()
