"""
    DeTai

Mã đề: DT038 - Đặt n quân hậu bằng quay lui (N-Queens with Backtracking)
Sinh viên: Dương Anh Kiệt
MSSV: N24DCDT043
Lớp: D24CQDT01-N
Giảng viên hướng dẫn: Hồ Nhựt Minh
Môn học: Cấu trúc dữ liệu và giải thuật (INT13185 — Nhóm 03)
Tài liệu tham khảo: Giáo trình Cấu trúc dữ liệu và Giải thuật (INT1306),
                   Chương 3, mục 3.4.3 & 3.4.4, Bài 3.2, trang in 73-75 (trang PDF 85-87).
"""
module DeTai

export kiem_tra_dau_vao,
       dat_hau!,
       kiem_tra_hau,
       in_ban_co,
       giai_bai,
       sinh_hoan_vi_vet_can,
       KetQuaNQueens

"""
    KetQuaNQueens

Cấu trúc lưu trữ kết quả giải bài toán n quân hậu bằng quay lui:
- `n`: Kích thước bàn cờ (n x n).
- `so_nghiem`: Tổng số cách đặt n quân hậu hợp lệ.
- `nghiem_dau`: Mảng n phần tử biểu diễn nghiệm đầu tiên (x[i] là cột đặt hậu ở hàng i), rỗng nếu vô nghiệm.
- `tat_ca_nghiem`: Danh sách toàn bộ các nghiệm tìm được (mỗi nghiệm là một Vector{Int}).
- `so_nut_goi`: Số nút trong cây không gian trạng thái đã duyệt (số lần gọi hàm dat_hau!).
- `so_lan_thu_cot`: Tổng số lần thử đặt hậu vào một cột trong vòng lặp.
- `so_nhanh_cat`: Số lần cắt nhánh do phát hiện xung đột cột hoặc đường chéo.
"""
struct KetQuaNQueens
    n::Int
    so_nghiem::Int
    nghiem_dau::Vector{Int}
    tat_ca_nghiem::Vector{Vector{Int}}
    so_nut_goi::Int
    so_lan_thu_cot::Int
    so_nhanh_cat::Int
end

"""
    kiem_tra_dau_vao(du_lieu)

Hợp đồng kiểm tra tính hợp lệ của đầu vào:
- Kiểu dữ liệu phải là số nguyên (Integer).
- Miền giá trị theo phiếu giao đề tài: 1 <= n <= 10.
- Ném lỗi `ArgumentError` kèm thông điệp rõ ràng nếu dữ liệu không hợp lệ.
"""
function kiem_tra_dau_vao(du_lieu)
    if !(du_lieu isa Integer)
        throw(ArgumentError("Kích thước bàn cờ n phải là số nguyên, nhận được kiểu: $(typeof(du_lieu))"))
    end
    n = Int(du_lieu)
    if n < 1
        throw(ArgumentError("Kích thước bàn cờ n phải >= 1 theo phiếu đề tài, nhận được: $n"))
    end
    if n > 10
        throw(ArgumentError("Kích thước bàn cờ n phải <= 10 theo phiếu đề tài, nhận được: $n"))
    end
    return n
end

"""
    kiem_tra_hau(x::Vector{Int}) -> Bool

Hàm kiểm tra độc lập từng cặp quân hậu:
Cho một cấu hình nghiệm x độ dài n (với x[i] là cột của quân hậu tại hàng i).
Kiểm tra xem có bất kỳ hai quân hậu nào cùng cột hoặc cùng đường chéo không.
Trả về `true` nếu hợp lệ, `false` nếu có xung đột.
"""
function kiem_tra_hau(x::Vector{Int})::Bool
    n = length(x)
    if n <= 1
        return true
    end
    for i in 1:n
        # Kiểm tra chỉ số cột hợp lệ từ 1 đến n
        if x[i] < 1 || x[i] > n
            return false
        end
        for j in (i + 1):n
            # Cùng cột
            if x[i] == x[j]
                return false
            end
            # Cùng đường chéo: |x[i] - x[j]| == |i - j|
            if abs(x[i] - x[j]) == abs(i - j)
                return false
            end
        end
    end
    return true
end

"""
    in_ban_co(x::Vector{Int}; io::IO = stdout)

In bàn cờ n x n tương ứng với nghiệm x:
- Hàng i, cột x[i] hiển thị quân hậu 'Q'.
- Các ô còn lại hiển thị dấu chấm '.'.
- Có viền và chỉ số hàng/cột để người đọc dễ theo dõi.
"""
function in_ban_co(x::Vector{Int}; io::IO = stdout)
    n = length(x)
    if isempty(x)
        println(io, "  (Bàn cờ rỗng do bài toán không có nghiệm)")
        return
    end
    println(io, "   " * join([" $j" for j in 1:n], " "))
    println(io, "  +" * repeat("---", n) * "+")
    for i in 1:n
        hang_str = [x[i] == j ? " Q" : " ." for j in 1:n]
        println(io, lpad(i, 2) * "| " * join(hang_str, " ") * " |")
    end
    println(io, "  +" * repeat("---", n) * "+")
end

"""
    dat_hau!(i::Int, n::Int, x::Vector{Int}, cot::BitVector, cheo1::BitVector, cheo2::BitVector,
             tat_ca_nghiem::Vector{Vector{Int}}, thong_ke::Dict{Symbol, Int})

Hàm đệ quy quay lui đặt hậu tại hàng i (1 <= i <= n+1):
- `i`: Hàng đang xét đặt hậu.
- `n`: Kích thước bàn cờ.
- `x`: Mảng lưu vị trí cột hiện thời của từng hàng.
- `cot`: Mảng đánh dấu cột đã có hậu hay chưa (kích thước n).
- `cheo1`: Mảng đánh dấu đường chéo chính theo tổng i + j (kích thước 2n).
- `cheo2`: Mảng đánh dấu đường chéo phụ theo hiệu i - j + n (kích thước 2n).
- `tat_ca_nghiem`: Danh sách ghi nhận các lời giải đầy đủ.
- `thong_ke`: Bộ đếm số nút cây duyệt, số lần thử cột và số nhánh bị cắt.
"""
function dat_hau!(i::Int, n::Int, x::Vector{Int}, cot::BitVector, cheo1::BitVector, cheo2::BitVector,
                  tat_ca_nghiem::Vector{Vector{Int}}, thong_ke::Dict{Symbol, Int})
    # Tăng số nút cây trạng thái được ghé thăm
    thong_ke[:so_nut_goi] += 1

    # Điều kiện dừng: đã đặt thành công n quân hậu từ hàng 1 đến hàng n
    if i > n
        push!(tat_ca_nghiem, copy(x))
        thong_ke[:so_nghiem] += 1
        return
    end

    # Thử từng cột j tăng dần từ 1 đến n
    for j in 1:n
        thong_ke[:so_lan_thu_cot] += 1
        # Điều kiện chấp nhận: cột j, chéo xuôi (i+j) và chéo ngược (i-j+n) đều chưa bị chiếm
        if !cot[j] && !cheo1[i + j] && !cheo2[i - j + n]
            # Đặt thử quân hậu tại ô (i, j)
            x[i] = j
            cot[j] = true
            cheo1[i + j] = true
            cheo2[i - j + n] = true

            # Đệ quy sang hàng tiếp theo i + 1
            dat_hau!(i + 1, n, x, cot, cheo1, cheo2, tat_ca_nghiem, thong_ke)

            # Hoàn tác (backtracking): trả lại trạng thái để nhánh khác thử tiếp
            cot[j] = false
            cheo1[i + j] = false
            cheo2[i - j + n] = false
            x[i] = 0
        else
            # Nhánh bị cắt do vi phạm ràng buộc
            thong_ke[:so_nhanh_cat] += 1
        end
    end
end

"""
    giai_bai(du_lieu) -> KetQuaNQueens

Hàm giao diện chính giải bài toán n quân hậu theo yêu cầu đề tài DT038:
1. Xác thực đầu vào bằng `kiem_tra_dau_vao`.
2. Khởi tạo 3 mảng đánh dấu BitVector: `cot(n)`, `cheo1(2n)`, `cheo2(2n)`.
3. Chạy thuật toán quay lui `dat_hau!`.
4. Trả về đối tượng `KetQuaNQueens` đầy đủ thông tin.
"""
function giai_bai(du_lieu)::KetQuaNQueens
    n = kiem_tra_dau_vao(du_lieu)

    x = zeros(Int, n)
    cot = falses(n)
    cheo1 = falses(2n)
    cheo2 = falses(2n)

    tat_ca_nghiem = Vector{Vector{Int}}()
    thong_ke = Dict{Symbol, Int}(
        :so_nghiem => 0,
        :so_nut_goi => 0,
        :so_lan_thu_cot => 0,
        :so_nhanh_cat => 0
    )

    # Gọi bắt đầu từ hàng 1
    dat_hau!(1, n, x, cot, cheo1, cheo2, tat_ca_nghiem, thong_ke)

    nghiem_dau = isempty(tat_ca_nghiem) ? Int[] : tat_ca_nghiem[1]

    return KetQuaNQueens(
        n,
        thong_ke[:so_nghiem],
        nghiem_dau,
        tat_ca_nghiem,
        thong_ke[:so_nut_goi],
        thong_ke[:so_lan_thu_cot],
        thong_ke[:so_nhanh_cat]
    )
end

"""
    sinh_hoan_vi_vet_can(n::Int)

(Yêu cầu nâng cao / Bài tập 3.2):
Sinh tất cả n! hoán vị của các cột rồi kiểm tra điều kiện chéo độc lập.
Trả về bộ (so_nghiem, so_hoan_vi_xet, thoi_gian_giay) để đối chiếu với quay lui.
"""
function sinh_hoan_vi_vet_can(n::Int)
    kiem_tra_dau_vao(n)
    so_hoan_vi = 0
    so_nghiem = 0
    t0 = time()

    function quay_lui_hoan_vi(i, p, da_dung)
        if i > n
            so_hoan_vi += 1
            if kiem_tra_hau(p)
                so_nghiem += 1
            end
            return
        end
        for val in 1:n
            if !da_dung[val]
                p[i] = val
                da_dung[val] = true
                quay_lui_hoan_vi(i + 1, p, da_dung)
                da_dung[val] = false
            end
        end
    end

    p = zeros(Int, n)
    da_dung = falses(n)
    quay_lui_hoan_vi(1, p, da_dung)
    tg = time() - t0
    return (so_nghiem = so_nghiem, so_hoan_vi = so_hoan_vi, thoi_gian = tg)
end

end # module DeTai
