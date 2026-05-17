/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.hotelmanagementsystem;


import java.awt.BorderLayout;
import java.awt.Dimension;
import java.awt.event.*;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import javax.swing.*;
import javax.swing.event.ListSelectionEvent;
import javax.swing.event.ListSelectionListener;

public class HotelTableGUI extends JFrame {

    JTable myTable;
    HotelTableModel tableModel;
    ArrayList<HotelStaff> list;

    public HotelTableGUI(ArrayList<HotelStaff> list) {
        this.setTitle("Staff in Hotel Management System");
        this.list = list;
        tableModel = new HotelTableModel(list);
        myTable = new JTable(tableModel);

        setBounds(20, 20, 800, 600);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        myTable.setAutoCreateRowSorter(true);

        JScrollPane scrollPane = new JScrollPane(myTable);
        scrollPane.setPreferredSize(new Dimension(380, 280));

        JButton button = new JButton("Info");
        button.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                saveHotelStaffReport();
            }
        });

        myTable.getSelectionModel().addListSelectionListener(new ListSelectionListener() {
            @Override
            public void valueChanged(ListSelectionEvent e) {
                // Not implemented
            }
        });

        myTable.addMouseListener(new MouseAdapter() {
            @Override
            public void mouseClicked(MouseEvent e){
                if (e.getClickCount() == 2) {
                    showSelectedStaffInfo();
                }
            }
        });

        add(scrollPane, BorderLayout.CENTER);
        add(button, BorderLayout.SOUTH);
    }

    private void showSelectedStaffInfo() {
        int selectedRow = myTable.getSelectedRow();
        if (selectedRow >= 0) {
            HotelStaff selectedStaff = list.get(selectedRow);
            String message = "Name: " + selectedStaff.getName() + "\n"
                    + "Surname: " + selectedStaff.getSurname();
            JOptionPane.showMessageDialog(this, message, "Staff Info", JOptionPane.INFORMATION_MESSAGE);
        }
    }

    private void saveHotelStaffReport() {
        try (PrintWriter writer = new PrintWriter(new FileWriter("HotelStaffReport.txt"))) {
            writer.println("Hotel Staff Report");
            for (HotelStaff staff : list) {
                writer.println(staff.getName() + "\t" + staff.getSurname());
            }
            JOptionPane.showMessageDialog(this, "Report saved to HotelStaffReport.txt");
        } catch (IOException ex) {
            JOptionPane.showMessageDialog(this, "Error saving report.");
        }
    }
}