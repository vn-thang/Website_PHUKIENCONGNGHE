/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.Date;

/**
 *
 * @author Thang
 */
public class Review {
    private int maDanhGia;
    private int maNguoiDung;
    private int maSanPham;
    private int soSao;
    private String noiDung;
    private Date ngayDanhGia;
    private String tenUser; 
    private int trangThai;
    private String phanHoi;
    private Product product; 

    public Review() {}

    public Review(int maDanhGia, int maNguoiDung, int maSanPham, int soSao, String noiDung, Date ngayDanhGia, String tenUser) {
        this.maDanhGia = maDanhGia;
        this.maNguoiDung = maNguoiDung;
        this.maSanPham = maSanPham;
        this.soSao = soSao;
        this.noiDung = noiDung;
        this.ngayDanhGia = ngayDanhGia;
        this.tenUser = tenUser;
        this.trangThai = 1; 
        this.phanHoi = null;
    }

    // Getters
    public int getMaDanhGia() { return maDanhGia; }
    public int getMaNguoiDung() { return maNguoiDung; }
    public int getMaSanPham() { return maSanPham; }
    public int getSoSao() { return soSao; }
    public String getNoiDung() { return noiDung; }
    public Date getNgayDanhGia() { return ngayDanhGia; }
    public String getTenUser() { return tenUser; }
    public int getTrangThai() { return trangThai; }  
    public String getPhanHoi() { return phanHoi; }
    public Product getProduct() { return product; }
    // Setters
    public void setMaDanhGia(int maDanhGia) { this.maDanhGia = maDanhGia; }
    public void setMaNguoiDung(int maNguoiDung) { this.maNguoiDung = maNguoiDung; }
    public void setMaSanPham(int maSanPham) { this.maSanPham = maSanPham; }
    public void setSoSao(int soSao) { this.soSao = soSao; }
    public void setNoiDung(String noiDung) { this.noiDung = noiDung; }
    public void setNgayDanhGia(Date ngayDanhGia) { this.ngayDanhGia = ngayDanhGia; }
    public void setTenUser(String tenUser) { this.tenUser = tenUser; }
     public void setTrangThai(int trangThai) { this.trangThai = trangThai; }
     public void setPhanHoi(String phanHoi) { this.phanHoi = phanHoi; }
      public void setProduct(Product product) { this.product = product; }

}
