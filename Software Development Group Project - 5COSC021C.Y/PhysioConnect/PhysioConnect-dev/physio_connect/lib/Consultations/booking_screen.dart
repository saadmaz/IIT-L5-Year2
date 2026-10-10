import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'support_chat_screen.dart';

class BookingScreen extends StatefulWidget {
  final String therapistName;
  final String therapistSpecialty;

  const BookingScreen(
      {Key? key, required this.therapistName, required this.therapistSpecialty})
      : super(key: key);

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime selectedDate = DateTime.now().add(Duration(days: 1));
  TimeOfDay selectedTime = TimeOfDay(hour: 9, minute: 0);
  bool isDateTimeSelected = false;
  bool isBookingConfirmed = false;

  List<TimeOfDay> availableTimes = [
    TimeOfDay(hour: 9, minute: 0),
    TimeOfDay(hour: 10, minute: 0),
    TimeOfDay(hour: 11, minute: 0),
    TimeOfDay(hour: 13, minute: 0),
    TimeOfDay(hour: 14, minute: 0),
    TimeOfDay(hour: 15, minute: 0),
    TimeOfDay(hour: 16, minute: 0),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Appointment'),
        backgroundColor: Colors.green.shade700,
      ),
      body: isBookingConfirmed
          ? _buildConfirmationScreen(widget, selectedTime, selectedDate)
          : _buildBookingScreen(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SupportChatScreen()),
          );
        },
        backgroundColor: Colors.green.shade700,
        child: Icon(Icons.support_agent),
        tooltip: 'Contact Support',
      ),
    );
  }

  Widget _buildBookingScreen() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Therapist info card
          Card(
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/doctor_icon.jpg'),
                    radius: 30,
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.therapistName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Specialization: ${widget.therapistSpecialty}',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24),

          // Date selection
          Text(
            'Select Date',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Container(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 14, // Show next 14 days
              itemBuilder: (context, index) {
                final date = DateTime.now().add(Duration(days: index + 1));
                final isSelected = selectedDate.year == date.year &&
                    selectedDate.month == date.month &&
                    selectedDate.day == date.day;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDate = date;
                      isDateTimeSelected = true;
                    });
                  },
                  child: Container(
                    width: 60,
                    margin: EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.green.shade600
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('E').format(date), // Day name
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          DateFormat('d').format(date), // Day number
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          DateFormat('MMM').format(date), // Month
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 24),

          // Time selection
          Text(
            'Select Time',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: availableTimes.map((time) {
              final isSelected = selectedTime.hour == time.hour &&
                  selectedTime.minute == time.minute;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedTime = time;
                    isDateTimeSelected = true;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.green.shade600
                        : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${time.hour}:${time.minute.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 24),

          // Session details
          Card(
            margin: EdgeInsets.symmetric(vertical: 12),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Session Details',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Session Duration'),
                      Text('45 minutes'),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Consultation Fee'),
                      Text('Rs 2500 .00'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24),

          // Book button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isDateTimeSelected
                  ? () {
                      setState(() {
                        isBookingConfirmed = true;
                      });
                    }
                  : null,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text('Confirm Booking'),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildConfirmationScreen(
    dynamic widget, dynamic selectedTime, dynamic selectedDate) {
  String formattedDate = DateFormat('EEEE, MMMM d, yyyy').format(selectedDate);
  String formattedTime =
      '${selectedTime.hour}:${selectedTime.minute.toString().padLeft(2, '0')}';

  return Center(
    child: Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 80,
          ),
          SizedBox(height: 24),
          Text(
            'Booking Confirmed!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade700,
            ),
          ),
          SizedBox(height: 16),
          Card(
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.person, color: Colors.green.shade600),
                    title: Text('Therapist'),
                    subtitle: Text(widget.therapistName),
                  ),
                  ListTile(
                    leading: Icon(Icons.medical_services,
                        color: Colors.green.shade600),
                    title: Text('Specialty'),
                    subtitle: Text(widget.therapistSpecialty),
                  ),
                  ListTile(
                    leading: Icon(Icons.calendar_today,
                        color: Colors.green.shade600),
                    title: Text('Date'),
                    subtitle: Text(formattedDate),
                  ),
                  ListTile(
                    leading:
                        Icon(Icons.access_time, color: Colors.green.shade600),
                    title: Text('Time'),
                    subtitle: Text(formattedTime),
                  ),
                  ListTile(
                    leading: Icon(Icons.timer, color: Colors.green.shade600),
                    title: Text('Duration'),
                    subtitle: Text('45 minutes'),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24),
          Text(
            'A confirmation has been sent to your email.',
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                icon: Icon(Icons.home),
                label: Text('Home'),
                onPressed: () {
                  // Navigator.of(context).pushAndRemoveUntil(
                  //     MaterialPageRoute(builder: (context) => HomeScreen()),
                  //     (Route<dynamic> route) => false);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                ),
              ),
              ElevatedButton.icon(
                icon: Icon(Icons.calendar_month),
                label: Text('My Bookings'),
                onPressed: () {
                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (context) => MyBookingsScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
