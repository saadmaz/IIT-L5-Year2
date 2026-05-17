/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.hotelmanagementsystem;

import java.util.ArrayList;
import javax.swing.table.AbstractTableModel;

public class HotelTableModel extends AbstractTableModel {
    private String[] columnNames = {"Staff ID", "Name", "Surname", "Date of Birth", "Role"};
    private ArrayList<HotelStaff> list;

    public HotelTableModel(ArrayList<HotelStaff> staffList) {
        list = staffList;
    }

    @Override
    public int getRowCount() {
        return list.size();
    }

    @Override
    public int getColumnCount() {
        return columnNames.length;
    }

    @Override
    public Object getValueAt(int rowIndex, int columnIndex) {
        HotelStaff staff = list.get(rowIndex);
        switch (columnIndex) {
            case 0:
                return staff.getStaffID(); // Staff ID
            case 1:
                return staff.getName();
            case 2:
                return staff.getSurname();
            case 3:
                return staff.getStringDate();
            case 4:
                if (staff instanceof Manager) {
                    return "Manager";
                } else if (staff instanceof HouseKeeper) {
                    return "HouseKeeper";
                } else {
                    return "Unknown";
                }
            default:
                return null;
        }
    }

    @Override
    public String getColumnName(int col) {
        return columnNames[col];
    }
}