/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.hotelmanagementsystem;

public class Guest{

    private String name;
    private String surname;
    private int roomNumber;
    private int nightsStayed;

    public Guest(String name, String surname) {
        this.name = name;
        this.surname = surname;
        roomNumber = 0;
        nightsStayed = 0;
    }

    // Setter and Getter methods
    public void setRoomNumber(int roomNumber) {
        this.roomNumber = roomNumber;
    }

    public void setNightsStayed(int nightsStayed) {
        this.nightsStayed = nightsStayed;
    }

    public int getRoomNumber() {
        return roomNumber;
    }

    public int getNightsStayed() {
        return nightsStayed;
    }

    @Override
    public String toString() {
        return super.toString() + " Guest - Room number: " + roomNumber + ", Nights stayed: " + nightsStayed;
    }
}
