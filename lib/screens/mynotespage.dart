import 'package:flutter/material.dart';
import 'addnote.dart';
import 'noteview.dart';
import 'package:intl/intl.dart'; // Import for formatting date and time
import '../services/db_repository.dart'; // Import your DatabaseRepository
import '../model/note.dart'; // Import your Note model

class Mynotespage extends StatefulWidget {
  const Mynotespage({super.key});

  @override
  _MynotespageState createState() => _MynotespageState();
}

class _MynotespageState extends State<Mynotespage> {
  List<Note> notes = [];
  List<Note> filteredNotes = [];
  final dbRepo = DatabaseRepository(); // Create an instance of DatabaseRepository

  final List<Color> containerColors = [
    Color(0xffF9E2FD),
    Color(0xffCDBDCB),
    Color(0xffD9D9D9),
    Color(0xffE7A9F2),
    Color(0xffF9E2FD),
    Color(0xffF9E2F0),
  ];

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  Future<void> loadNotes() async {
    List<Note> loadedNotes = await dbRepo.getNotes();
    setState(() {
      notes = loadedNotes;
      filteredNotes = loadedNotes; // Initialize with all notes
    });
  }

  Future<void> addNewNote(String title, String content) async {
    final now = DateTime.now();
    Note newNote = Note(
      title: title,
      description: content,
      createdAt: now,
    );

    await dbRepo.insertNote(newNote);
    loadNotes();
  }

  Future<void> editNote(int index, String title, String content) async {
    Note updatedNote = filteredNotes[index];
    updatedNote.title = title;
    updatedNote.description = content;

    await dbRepo.updateNote(updatedNote);
    loadNotes();
  }

  Future<void> deleteNoteConfirm(int index) async {
    int noteId = filteredNotes[index].id!;
    await dbRepo.deleteNote(noteId);
    loadNotes();
  }

  void filterNotes(String keyword) {
    setState(() {
      filteredNotes = notes.where((note) => note.title.toLowerCase().contains(keyword.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "My Notes...",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cursive',
            ),
          ),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xffEFCBF6), Color(0xffCDBDCB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          elevation: 8.0,
          actions: [
            // Search Popup Menu
            PopupMenuButton(
              icon: Icon(Icons.search, color: Colors.black),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Container(
                    width: 200, // Adjust width as needed
                    child: TextField(
                      onChanged: (value) => filterNotes(value),
                      decoration: InputDecoration(
                        hintText: "Search notes...",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Settings Popup Menu
            PopupMenuButton(
              icon: Icon(Icons.settings, color: Colors.black),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: ListTile(
                    leading: Icon(Icons.color_lens),
                    title: Text("Change Theme Color"),
                    onTap: () {
                      // Add theme change functionality here
                      Navigator.pop(context);
                    },
                  ),
                ),
                PopupMenuItem(
                  child: ListTile(
                    leading: Icon(Icons.font_download),
                    title: Text("Change Font Style"),
                    onTap: () {
                      // Add font change functionality here
                      Navigator.pop(context);
                    },
                  ),
                ),
                PopupMenuItem(
                  child: ListTile(
                    leading: Icon(Icons.info),
                    title: Text("About"),
                    onTap: () {
                      // Add about information here
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
        body: Container(
          color: Color(0xff965C99),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: filteredNotes.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NoteView(
                              title: filteredNotes[index].title,
                              content: filteredNotes[index].description,
                              date: DateFormat('MMM dd, yyyy').format(filteredNotes[index].createdAt),
                              time: DateFormat('hh:mm a').format(filteredNotes[index].createdAt),
                              onEdit: (newTitle, newContent) {
                                editNote(index, newTitle, newContent);
                              },
                              onDelete: () {
                                deleteNoteConfirm(index);
                              },
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: containerColors[index % containerColors.length],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                filteredNotes[index].title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                filteredNotes[index].description.length > 30
                                    ? filteredNotes[index].description.substring(0, 30) + '...'
                                    : filteredNotes[index].description,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.calendar_today, size: 14, color: Colors.black54),
                                      SizedBox(width: 4),
                                      Text(
                                        DateFormat('MMM dd, yyyy').format(filteredNotes[index].createdAt),
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(Icons.access_time, size: 14, color: Colors.black54),
                                      SizedBox(width: 4),
                                      Text(
                                        DateFormat('hh:mm a').format(filteredNotes[index].createdAt),
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.edit, color: Colors.black),
                                        onPressed: () async {
                                          final updatedNote = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Addnote(
                                                title: filteredNotes[index].title,
                                                content: filteredNotes[index].description,
                                              ),
                                            ),
                                          );

                                          if (updatedNote != null) {
                                            editNote(index, updatedNote['title'], updatedNote['content']);
                                          }
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete, color: Colors.black),
                                        onPressed: () {
                                          deleteNoteConfirm(index);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final newNote = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Addnote(),
              ),
            );

            if (newNote != null) {
              addNewNote(newNote['title'], newNote['content']);
            }
          },
          backgroundColor: Colors.black,
          child: Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
