/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.hotelmanagementsystem;

import java.awt.BorderLayout;
import java.awt.Dimension;
import java.util.ArrayList;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JScrollPane;
import javax.swing.JTable;

public class HotelTableGUI extends JFrame {

    JTable myTable;
    HotelTableModel tableModel;
    ArrayList<HotelStaff> list;

    public HotelTableGUI(ArrayList<HotelStaff> list) {
        this.setTitle("Staff in Hotel Management System");
        this.list = list;
        tableModel = new HotelTableModel(list);
        myTable = new JTable(tableModel);

        // Set the size of the frame
        setBounds(20, 20, 800, 600);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        // Enable sorting
        myTable.setAutoCreateRowSorter(true);

        // Add the table to the panel
        JScrollPane scrollPane = new JScrollPane(myTable);
        scrollPane.setPreferredSize(new Dimension(380, 280));

        // Add a button at the bottom
        JButton button = new JButton("Info");

        // Add the panel to the frame
        add(scrollPane, BorderLayout.CENTER);
        add(button, BorderLayout.SOUTH);
    }
}
