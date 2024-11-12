import 'package:flutter/material.dart';

class Addnote extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController contentController;

  // Constructor accepting title and content
  Addnote({Key? key, String? title, String? content})
      : titleController = TextEditingController(text: title),
        contentController = TextEditingController(text: content),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF7B4D86), // Dark purple background
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header with back button
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                color: Color(0xFFE1BEE7), // Light pinkish background
                width: double.infinity,
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              // Main Content with Title and Body
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Title Card
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Editable Title
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Color(0xFFD8BFD8), // Light purple background for title
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextField(
                              controller: titleController,
                              decoration: InputDecoration(
                                hintText: 'Enter Title',
                                border: InputBorder.none,
                              ),
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Cursive',
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          // Editable Note content area
                          Container(
                            height: 300,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.grey[300], // Light grey background for content
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: SingleChildScrollView(
                              child: TextField(
                                controller: contentController,
                                decoration: InputDecoration(
                                  hintText: 'Enter Content',
                                  border: InputBorder.none,
                                ),
                                maxLines: null,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Save Button
                    ElevatedButton(
                      onPressed: () {
                        final title = titleController.text;
                        final content = contentController.text;

                        if (title.isNotEmpty || content.isNotEmpty) {
                          Navigator.pop(context, {
                            'title': title,
                            'content': content,
                          }); // Return title and content to Mynotespage
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(vertical: 35),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Save Note',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
