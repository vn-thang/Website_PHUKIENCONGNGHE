/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;



public class OrderDetail {
    private int maChiTiet;
    private int maDonHang;
    private int maSanPham;
    private int soLuong;
    private double donGia;
    private Product product;

    public OrderDetail() {
    }

    public OrderDetail(Product product,int soLuong, double donGia) {
      this.product = product;
        this.soLuong = soLuong;
        this.donGia = donGia;
      
    }

    public OrderDetail(int maChiTiet, int maDonHang, int maSanPham, int soLuong, double donGia) {
        this.maChiTiet = maChiTiet;
        this.maDonHang = maDonHang;
        this.maSanPham = maSanPham;
        this.soLuong = soLuong;
        this.donGia = donGia;
    }

    // Getters and Setters
    public int getMaChiTiet() {
        return maChiTiet;
    }

    public void setMaChiTiet(int maChiTiet) {
        this.maChiTiet = maChiTiet;
    }

    public int getMaDonHang() {
        return maDonHang;
    }

    public void setMaDonHang(int maDonHang) {
        this.maDonHang = maDonHang;
    }

    public int getMaSanPham() {
        return maSanPham;
    }

    public void setMaSanPham(int maSanPham) {
        this.maSanPham = maSanPham;
    }

    public int getSoLuong() {
        return soLuong;
    }

    public void setSoLuong(int soLuong) {
        this.soLuong = soLuong;
    }

    public double getDonGia() {
        return donGia;
    }

    public void setDonGia(double donGia) {
        this.donGia = donGia;
    }
    public Product getProduct() {
        return product;
    }

    // [SỬA LỖI 1] THÊM HÀM setProduct()
    public void setProduct(Product product) {
        this.product = product;
    }

    // [SỬA LỖI 2] THÊM HÀM TỰ TÍNH TỔNG TIỀN
    public double getTotalPrice() {
        return this.soLuong * this.donGia;
    }
}
