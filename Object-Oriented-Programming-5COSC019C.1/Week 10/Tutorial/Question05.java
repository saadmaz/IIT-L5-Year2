// 5) Implement addDays in the Date class and write JUnit tests for correctness
// The main class is Question05, which contains the Date class and the JUnit test class.

public class Question05 {

    // --- Date class with addDays and equals ---
    public static class Date {
        private int day, month, year;

        public Date(int day, int month, int year) {
            this.day = day;
            this.month = month;
            this.year = year;
        }

        // Adds days to this Date, rolling over months/years as needed
        public void addDays(int days) {
            int[] daysInMonth = {0,31,28,31,30,31,30,31,31,30,31,30,31};
            day += days;
            while (true) {
                int dim = daysInMonth[month];

                // Handle leap year for February
                if (month == 2 && isLeapYear(year)) {
                    dim = 29;
                }

                if (day <= dim) break;

                day -= dim;
                month++;
                if (month > 12) {
                    month = 1;
                    year++;
                }
            }
        }

        // Leap year check for correct February days
        public boolean isLeapYear(int y) {
            return (y % 4 == 0 && y % 100 != 0) || (y % 400 == 0);
        }

        @Override
        public boolean equals(Object obj) {
            if (this == obj) return true;
            if (obj == null || getClass() != obj.getClass()) return false;
            Date other = (Date) obj;
            return this.day == other.day && this.month == other.month && this.year == other.year;
        }

        public void printDate() {
            System.out.println("The date is " + year + "-" +
                String.format("%02d", month) + "-" + String.format("%02d", day));
        }

        public int getDay() { return day; }
        public int getMonth() { return month; }
        public int getYear() { return year; }
    }
}

