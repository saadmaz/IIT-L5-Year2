package com.mycompany.hotelmanagementsystem;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class ManagerTest {

    @Test
    public void testConstructor() {
        Manager manager = new Manager("Saad", "Mazhar");
        assertEquals("Saad", manager.getName());
        assertEquals("Mazhar", manager.getSurname());
    }
}
