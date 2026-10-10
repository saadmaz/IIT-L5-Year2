/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.hotelmanagementsystem;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

/**
 *
 * @author b.villarini
 */

public class Manager extends HotelStaff {
    private String licenseNumber;

    public Manager(String name, String surname) {
        super(name, surname);
    }

    public void setLicenseNumber(String licenseNumber) {
        this.licenseNumber = licenseNumber;
    }

    public String getLicenseNumber() {
        return licenseNumber;
    }

    @Override
    public String toString() {
        return super.toString() + " Manager - License number: " + licenseNumber;
    }
}


@Test
public void testConstructor() {
    Manager manager = new Manager("Saad", "Mazhar");
    assertEquals("Saad", manager.getName());
    assertEquals("Mazhar", manager.getSurname());
}
