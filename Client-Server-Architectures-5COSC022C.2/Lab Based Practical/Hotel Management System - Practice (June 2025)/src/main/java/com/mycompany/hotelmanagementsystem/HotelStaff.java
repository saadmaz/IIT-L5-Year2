/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.hotelmanagementsystem;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

public abstract class HotelStaff {

    private String name;
    private String surname;
    private LocalDate dateOfBirth;
    private String staffID;

    public HotelStaff(String name, String surname) {
        this.name = name;
        this.surname = surname;
    }

    // Setter and Getter methods
    public void setName(String name) {
        this.name = name;
    }

    public void setSurname(String surname) {
        this.surname = surname;
    }

    public void setDateOfBirth(LocalDate dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public void setStaffID(String staffID) {
        this.staffID = staffID;
    }

    public String getName() {
        return name;
    }

    public String getSurname() {
        return surname;
    }

    public LocalDate getDateOfBirth() {
        return dateOfBirth;
    }

    public String getStaffID() {
        return staffID;
    }

    public String getStringDate() {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        return dateOfBirth.format(formatter);
    }

    @Override
    public String toString() {
        return name + " " + surname + ", ID: " + staffID + ", DOB: " + getStringDate();
    }
}
