/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

public class Product {
    private int maSanPham;
    private String tenSanPham;
    private String hinhAnh;
    private double gia;
    private String moTa;
    private int soLuongTon;
    private int maDanhMuc;

    public Product() {
    }

    public Product(int maSanPham, String tenSanPham, String hinhAnh, double gia, String moTa, int soLuongTon, int maDanhMuc) {
        this.maSanPham = maSanPham;
        this.tenSanPham = tenSanPham;
        this.hinhAnh = hinhAnh;
        this.gia = gia;
        this.moTa = moTa;
        this.soLuongTon = soLuongTon;
        this.maDanhMuc = maDanhMuc;
    }
public Product(int maSanPham, String tenSanPham, String hinhAnh) {
        this.maSanPham = maSanPham;
        this.tenSanPham = tenSanPham;
        this.hinhAnh = hinhAnh;
}
// Getters and Setters for all fields
    public int getMaSanPham() {
        return maSanPham;
    }

    public void setMaSanPham(int maSanPham) {
        this.maSanPham = maSanPham;
    }

    public String getTenSanPham() {
        return tenSanPham;
    }

    public void setTenSanPham(String tenSanPham) {
        this.tenSanPham = tenSanPham;
    }

    public String getHinhAnh() {
        return hinhAnh;
    }

    public void setHinhAnh(String hinhAnh) {
        this.hinhAnh = hinhAnh;
    }

    public double getGia() {
        return gia;
    }

    public void setGia(double gia) {
        this.gia = gia;
    }

    public String getMoTa() {
        return moTa;
    }

    public void setMoTa(String moTa) {
        this.moTa = moTa;
    }

    public int getSoLuongTon() {
        return soLuongTon;
    }

    public void setSoLuongTon(int soLuongTon) {
        this.soLuongTon = soLuongTon;
    }

    public int getMaDanhMuc() {
        return maDanhMuc;
    }

    public void setMaDanhMuc(int maDanhMuc) {
        this.maDanhMuc = maDanhMuc;
    }
}

