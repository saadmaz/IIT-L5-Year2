import 'package:flutter/material.dart';
import 'therapist.dart';

class TherapistCard extends StatelessWidget {
  final Therapist therapist;
  final VoidCallback onBookPressed;

  TherapistCard({required this.therapist, required this.onBookPressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: Column(
        children: [
          // Image takes up half the card
          Expanded(
            flex: 1, // Half of the card
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.asset(
                therapist.image,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Text and button take up the other half
          Expanded(
            flex: 1, // Half of the card
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    therapist.name,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    therapist.specialty,
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 18),
                      SizedBox(width: 5),
                      Text(therapist.rating.toString(),
                          style: TextStyle(fontSize: 14)),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: onBookPressed,
                    child: Text('Book Now'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          therapist.available ? Colors.green : Colors.grey,
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
