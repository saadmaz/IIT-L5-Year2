package com.mycompany.hotelmanagementsystem;

import static java.lang.Character.getName;

public class Chef extends HotelStaff {
    private int yearsOfExperience;
    private String speciality;

    public Chef(String name, String surname) {
        super(name, surname);
    }

    public int getYearsOfExperience() {
        return yearsOfExperience;
    }

    public void setYearsOfExperience(int yearsOfExperience) {
        this.yearsOfExperience = yearsOfExperience;
    }

    public String getSpeciality() {
        return speciality;
    }

    public void setSpeciality(String speciality) {
        this.speciality = speciality;
    }

    @Override
    public String toString() {
        return "Chef{" +
                "name='" + getName() + '\'' +
                ", surname='" + getSurname() + '\'' +
                ", dateOfBirth='" + getDateOfBirth() + '\'' +
                ", staffID='" + getStaffID() + '\'' +
                ", yearsOfExperience=" + yearsOfExperience +
                ", speciality='" + speciality + '\'' +
                '}';
    }

    public String getStaffID() {
    }

    private String getDateOfBirth() {
    }

    private String getSurname() {
    }
}