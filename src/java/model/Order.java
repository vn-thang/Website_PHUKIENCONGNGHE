/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;



import java.util.Date;

public class Order {
    private int maDonHang;
    private int maNguoiDung;
    private Date ngayDat;
    private double tongTien;
    private String trangThai;
    private String hoTenNguoiNhan;
    private String sdtNguoiNhan;
    private String diaChiNhanHang;
    // ... (các trường private khác của bạn)
    private String tenNguoiDat; // Tên của người dùng đặt hàng (lấy từ bảng nguoidung)
    public Order() {
    }
    
    // ========== HÀM KHỞI TẠO MỚI (ĐỂ DAO SỬ DỤNG) ==========
    public Order(int maDonHang, Date ngayDat, double tongTien, String trangThai, String hoTenNguoiNhan, String sdtNguoiNhan, String diaChiNhanHang) {
        this.maDonHang = maDonHang;
        this.ngayDat = ngayDat;
        this.tongTien = tongTien;
        this.trangThai = trangThai;
        this.hoTenNguoiNhan = hoTenNguoiNhan;
        this.sdtNguoiNhan = sdtNguoiNhan;
        this.diaChiNhanHang = diaChiNhanHang;
    }
public String getTrangThai() {
        return trangThai;
    }
public String getTenNguoiDat() {
        return tenNguoiDat;
    }
    public void setTrangThai(String trangThai) {
        this.trangThai = trangThai;
    }

    public String getHoTenNguoiNhan() {
        return hoTenNguoiNhan;
    }

    public void setHoTenNguoiNhan(String hoTenNguoiNhan) {
        this.hoTenNguoiNhan = hoTenNguoiNhan;
    }

    public String getSdtNguoiNhan() {
        return sdtNguoiNhan;
    }

    public void setSdtNguoiNhan(String sdtNguoiNhan) {
        this.sdtNguoiNhan = sdtNguoiNhan;
    }

    public String getDiaChiNhanHang() {
        return diaChiNhanHang;
    }

    public void setDiaChiNhanHang(String diaChiNhanHang) {
        this.diaChiNhanHang = diaChiNhanHang;
    }
    // Getters and Setters
    public int getMaDonHang() {
        return maDonHang;
    }
public void setTenNguoiDat(String tenNguoiDat) {
        this.tenNguoiDat = tenNguoiDat;
    }
    public void setMaDonHang(int maDonHang) {
        this.maDonHang = maDonHang;
    }

    public int getMaNguoiDung() {
        return maNguoiDung;
    }

    public void setMaNguoiDung(int maNguoiDung) {
        this.maNguoiDung = maNguoiDung;
    }

    public Date getNgayDat() {
        return ngayDat;
    }

    public void setNgayDat(Date ngayDat) {
        this.ngayDat = ngayDat;
    }

    public double getTongTien() {
        return tongTien;
    }

    public void setTongTien(double tongTien) {
        this.tongTien = tongTien;
    }
    
}

