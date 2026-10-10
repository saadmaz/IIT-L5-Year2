/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.hotelmanagementsystem;

public class HouseKeeper extends HotelStaff {
    private int yearsOfExperience;

    public HouseKeeper(String name, String surname) {
        super(name, surname);
    }

    // Setter and Getter methods
    public void setYearsOfExperience(int yearsOfExperience) {
        this.yearsOfExperience = yearsOfExperience;
    }

    public int getYearsOfExperience() {
        return yearsOfExperience;
    }

    @Override
    public String toString() {
        return super.toString() + " Housekeeper - Years of Experience: " + yearsOfExperience ;
    }
}
