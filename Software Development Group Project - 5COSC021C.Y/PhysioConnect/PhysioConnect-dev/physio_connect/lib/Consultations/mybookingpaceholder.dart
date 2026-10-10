import 'package:flutter/material.dart';

class MyBookingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Bookings'),
        backgroundColor: Colors.green.shade700,
      ),
      body: Center(
        child: Text(
          'Your Bookings Will Appear Here',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
