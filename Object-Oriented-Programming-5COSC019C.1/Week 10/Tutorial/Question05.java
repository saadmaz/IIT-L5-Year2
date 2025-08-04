// 5) Implement addDays in the Date class and write JUnit tests for correctness
// Assume a simple Date class exists with day, month, year, and addDays method

// --- Date class with addDays and equals ---
public class Question05 {
    private int day, month, year;

    public Date(int day, int month, int year) {
        this.day = day;
        this.month = month;
        this.year = year;
    }

    // Adds days to this Date, rolling over months/years as needed
    public void addDays(int days) {
        // (Simple logic, not handling leap years or all months correctly, just for illustration)
        int[] daysInMonth = {0,31,28,31,30,31,30,31,31,30,31,30,31};
        day += days;
        while (day > daysInMonth[month]) {
            day -= daysInMonth[month];
            month++;
            if (month > 12) {
                month = 1;
                year++;
            }
        }
    }

    @Override
    public boolean equals(Object obj) {
        // Checks if obj is a Date and fields are equal
        if (this == obj) return true;
        if (!(obj instanceof Date)) return false;
        Date other = (Date) obj;
        return this.day == other.day && this.month == other.month && this.year == other.year;
    }

    // printDate method for testing output
    public void printDate() {
        System.out.println("The date is " + year + "-" + String.format("%02d", month) + "-" + String.format("%02d", day));
    }

    // Getters for tests
    public int getDay() { return day; }
    public int getMonth() { return month; }
    public int getYear() { return year; }
}

// --- DateTest class for JUnit (using JUnit 4 syntax) ---
import org.junit.*;
import static org.junit.Assert.*;
import java.io.*;

public class DateTest {
    @Before
    public void setUp() {}

    @After
    public void tearDown() {}

    // Test addDays on normal case
    @Test
    public void testAddDays() {
        Date d = new Date(12, 2, 2019);
        d.addDays(4);
        assertEquals(2019, d.getYear());
        assertEquals(2, d.getMonth());
        assertEquals(16, d.getDay());
    }

    // Test addDays that wraps to next month
    @Test
    public void testAddDays_wrapMonth() {
        Date d = new Date(28, 12, 2019);
        d.addDays(4);
        Date expected = new Date(1, 1, 2020);
        assertEquals(expected, d);
    }

    // Test printDate output
    @Test
    public void printDate_test() {
        // Prepare to capture output
        PrintStream originalOut = System.out;
        OutputStream os = new ByteArrayOutputStream();
        PrintStream ps = new PrintStream(os);
        System.setOut(ps);

        // Define line separator
        String separator = System.getProperty("line.separator");

        // Run test
        Date d = new Date(28, 12, 2019);
        d.printDate();
        assertEquals("The date is 2019-12-28" + separator, os.toString());

        // Restore normal output
        System.setOut(originalOut);
    }
}