using Test
include(joinpath(@__DIR__, "..", "src", "DeTai.jl"))
using .DeTai

println("="^70)
println("BẮT ĐẦU BỘ KIỂM THỬ ĐỘC LẬP CHO ĐỀ TÀI DT038 (N-QUEENS BACKTRACKING)")
println("Sinh viên: Dương Anh Kiệt — MSSV: N24DCDT043 — Lớp: D24CQDT01-N")
println("="^70)

@testset "BỘ KIỂM THỬ TỔNG THỂ DT038" begin

    @testset "Nhóm 1: Hai ví dụ chính trong phiếu giao đề tài" begin
        # TC01: Ví dụ 1 - n = 4
        local kq4 = giai_bai(4)
        @test kq4.n == 4
        @test kq4.so_nghiem == 2
        @test kq4.nghiem_dau == [2, 4, 1, 3]
        @test kq4.tat_ca_nghiem == [[2, 4, 1, 3], [3, 1, 4, 2]]
        @test kiem_tra_hau(kq4.nghiem_dau) == true

        # TC02: Ví dụ 2 - n = 3 (vô nghiệm)
        local kq3 = giai_bai(3)
        @test kq3.n == 3
        @test kq3.so_nghiem == 0
        @test isempty(kq3.nghiem_dau)
        @test isempty(kq3.tat_ca_nghiem)
    end

    @testset "Nhóm 2: Năm ca kiểm tra bắt buộc của đề bài" begin
        # TC03: Ca kiểm 1 - n = 1 (biên dưới cực tiểu)
        local kq1 = giai_bai(1)
        @test kq1.so_nghiem == 1
        @test kq1.nghiem_dau == [1]
        @test kiem_tra_hau(kq1.nghiem_dau) == true

        # TC04: Ca kiểm 2 - n = 2 (vô nghiệm)
        local kq2 = giai_bai(2)
        @test kq2.so_nghiem == 0
        @test isempty(kq2.nghiem_dau)

        # TC05: Ca kiểm 3 - n = 4 (kiểm tra lại số nghiệm)
        local kq4 = giai_bai(4)
        @test kq4.so_nghiem == 2
        @test length(kq4.tat_ca_nghiem) == 2

        # TC06: Ca kiểm 4 - n = 5 (10 nghiệm, không gộp đối xứng)
        local kq5 = giai_bai(5)
        @test kq5.so_nghiem == 10
        @test length(kq5.tat_ca_nghiem) == 10
        @test kq5.nghiem_dau == [1, 3, 5, 2, 4]
        @test kiem_tra_hau(kq5.nghiem_dau) == true

        # TC07: Ca kiểm 5 - n = 8 (92 nghiệm chuẩn quốc tế và sách giáo trình)
        local kq8 = giai_bai(8)
        @test kq8.so_nghiem == 92
        @test length(kq8.tat_ca_nghiem) == 92
        @test kq8.nghiem_dau == [1, 5, 8, 6, 3, 7, 2, 4]
        @test kiem_tra_hau(kq8.nghiem_dau) == true
        # Kiểm tra tất cả 92 nghiệm đều thỏa mãn kiểm tra độc lập từng cặp
        @test all(kiem_tra_hau, kq8.tat_ca_nghiem) == true
    end

    @testset "Nhóm 3: Các kích thước mở rộng và biên trên" begin
        # TC08: Quy mô n = 6
        local kq6 = giai_bai(6)
        @test kq6.so_nghiem == 4
        @test kq6.nghiem_dau == [2, 4, 6, 1, 3, 5]
        @test all(kiem_tra_hau, kq6.tat_ca_nghiem) == true

        # TC09: Quy mô n = 7
        local kq7 = giai_bai(7)
        @test kq7.so_nghiem == 40
        @test kq7.nghiem_dau == [1, 3, 5, 7, 2, 4, 6]
        @test all(kiem_tra_hau, kq7.tat_ca_nghiem) == true

        # TC10: Biên trên tối đa n = 10 theo phiếu giao
        local kq10 = giai_bai(10)
        @test kq10.so_nghiem == 724
        @test length(kq10.tat_ca_nghiem) == 724
        @test kiem_tra_hau(kq10.nghiem_dau) == true
    end

    @testset "Nhóm 4: Kiểm tra hợp đồng đầu vào (Validator từ chối dữ liệu sai)" begin
        # TC11: Dữ liệu n <= 0 (vi phạm cận dưới)
        @test_throws ArgumentError kiem_tra_dau_vao(0)
        @test_throws ArgumentError kiem_tra_dau_vao(-5)

        # TC12: Dữ liệu n > 10 (vi phạm cận trên phiếu giao)
        @test_throws ArgumentError kiem_tra_dau_vao(11)
        @test_throws ArgumentError kiem_tra_dau_vao(15)

        # TC13: Kiểu dữ liệu không phải số nguyên
        @test_throws ArgumentError kiem_tra_dau_vao(4.5)
        @test_throws ArgumentError kiem_tra_dau_vao("8")
        @test_throws ArgumentError kiem_tra_dau_vao(nothing)
    end

    @testset "Nhóm 5: Kiểm tra hàm độc lập và bất biến giải thuật" begin
        # TC14: Hàm kiem_tra_hau phát hiện chính xác các xung đột
        @test kiem_tra_hau([2, 4, 1, 3]) == true
        @test kiem_tra_hau([1, 1, 2, 3]) == false      # Trùng cột
        @test kiem_tra_hau([1, 2, 3, 4]) == false      # Trùng đường chéo xuôi
        @test kiem_tra_hau([4, 3, 2, 1]) == false      # Trùng đường chéo ngược
        @test kiem_tra_hau([1, 5, 8, 6, 3, 7, 2, 4]) == true
        @test kiem_tra_hau([1, 5, 8, 6, 3, 7, 4, 2]) == false # Xung đột chéo ở cuối

        # TC15: Hiệu quả cắt nhánh (Số nút quay lui khớp chính xác Bảng 3.4 giáo trình)
        local kq4 = giai_bai(4)
        local kq5 = giai_bai(5)
        local kq6 = giai_bai(6)
        local kq8 = giai_bai(8)

        # n = 4: 17 nút quay lui < 24 (4!)
        @test kq4.so_nut_goi == 17
        # n = 5: 54 nút quay lui < 120 (5!)
        @test kq5.so_nut_goi == 54
        # n = 6: 153 nút quay lui < 720 (6!)
        @test kq6.so_nut_goi == 153
        # n = 8: 2057 nút quay lui < 40320 (8!)
        @test kq8.so_nut_goi == 2057
        # Số nhánh bị cắt lớn hơn 0
        @test kq4.so_nhanh_cat > 0
        @test kq8.so_nhanh_cat > 0
    end
end

println("="^70)
println("TẤT CẢ CÁC CA KIỂM THỬ ĐÃ CHẠY HOÀN TẤT VÀ ĐẠT 100%!")
println("="^70)
