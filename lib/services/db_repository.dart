import 'package:path/path.dart'; // For handling file paths
import 'package:sqflite/sqflite.dart'; // SQLite package for Flutter
import '../model/note.dart'; // Import Note model

class DatabaseRepository {
  static final DatabaseRepository _instance = DatabaseRepository._internal(); // Singleton instance
  static Database? _database;

  // Factory constructor for singleton pattern
  factory DatabaseRepository() {
    return _instance;
  }

  DatabaseRepository._internal();

  // Getter for the database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the SQLite database
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'notes_database.db'); // Database path
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Create the 'notes' table in the database
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');
  }

  // Insert a new note into the database
  Future<int> insertNote(Note note) async {
    final db = await database;
    return await db.insert(
      'notes',
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Retrieve all notes from the database
  Future<List<Note>> getNotes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('notes');

    return List.generate(maps.length, (i) {
      return Note.fromMap(maps[i]);
    });
  }

  // Update an existing note in the database
  Future<int> updateNote(Note note) async {
    final db = await database;
    return await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?', 
      whereArgs: [note.id],
    );
  }

  // Delete a note from the database by its id
  Future<int> deleteNote(int id) async {
    final db = await database;
    return await db.delete(
      'notes',
      where: 'id = ?', 
      whereArgs: [id],
    );
  }

  // Close the database connection
  Future close() async {
    final db = await database;
    db.close();
  }
}
