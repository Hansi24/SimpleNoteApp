import 'package:cw1/screens/addnote.dart';
import 'package:flutter/material.dart';

class NoteView extends StatelessWidget {
  final String title;
  final String content;
  final String date;
  final String time;
  final Function(String, String) onEdit; // Callback for editing the note
  final Function() onDelete; // Callback for deleting the note

  const NoteView({
    Key? key,
    required this.title,
    required this.content,
    required this.date,
    required this.time,
    required this.onEdit, // Added callback for editing
    required this.onDelete, // Added callback for deleting
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notes',
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: false,
        backgroundColor: const Color.fromARGB(255, 201, 86, 182),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Title
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 76, 5, 77),
                  ),
                ),
                // Action Buttons
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: const Color.fromARGB(255, 220, 89, 187)),
                      onPressed: () async {
                        // Navigate to edit note screen and await result
                        final updatedNote = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Addnote(
                              title: title,
                              content: content,
                            ),
                          ),
                        );

                        // If updatedNote is not null, call onEdit
                        if (updatedNote != null) {
                          onEdit(updatedNote['title'], updatedNote['content']);
                          Navigator.pop(context); // Go back to the previous screen
                        }
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        // Call onDelete callback to handle deletion
                        onDelete();
                        Navigator.pop(context); // Go back to the previous screen
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Date and Time
            Text(
              '$date at $time', // Combine date and time
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 20),

            // Content Box
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 3), // Shadow position
                  ),
                ],
              ),
              child: Text(
                content,
                style: TextStyle(
                  fontSize: 18,
                  height: 1.5,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
