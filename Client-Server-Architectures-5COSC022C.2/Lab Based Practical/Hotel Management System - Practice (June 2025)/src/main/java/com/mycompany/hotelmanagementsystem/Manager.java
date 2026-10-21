/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.hotelmanagementsystem;

/**
 *
 * @author b.villarini
 */
public class Manager extends HotelStaff {

    private String licenseNumber;
   

    public Manager(String name, String surname) {
        super(name, surname);
    }

    // Setter and Getter methods
    public void setLicenseNumber(String licenseNumber) {
        this.licenseNumber = licenseNumber;
    }

    public String getLicenseNumber() {
        return licenseNumber;
    }


    @Override
    public String toString() {
        return super.toString() + " Manager - License number: " + licenseNumber ;
    }
}
