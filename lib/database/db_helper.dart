import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/expense.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;                           //   hard
  DBHelper._internal();

  static Database? _database;
  static const String _tableName = 'expenses';


  // Initialize the database.
  Future<Database> _initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'expense_tracker.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Get the database instance, initializing it if it hasn't been already.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  // Create the expenses table.
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        amount REAL NOT NULL,
        category TEXT NOT NULL,
        date TEXT NOT NULL,
        note TEXT
      )
    ''');
  }

  // --- CRUD Operations ---

  // Create (Insert) a new expense
  Future<int> createExpense(Expense expense) async {
    final db = await database;
    // The toMap() method handles converting the Expense object to a Map
    return await db.insert(
      _tableName,
      expense.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Read (Retrieve) all expenses
  Future<List<Expense>> getExpenses() async {
    final db = await database;
    // Query the table, ordered by date descending
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      orderBy: 'date DESC, id DESC',
    );

    // Convert the List<Map<String, dynamic>> to List<Expense>                      
    List<Expense> expenses = [];
    for (var map in maps) {
      expenses.add(Expense.fromMap(map));
    }
    return expenses;
}

  // Update an existing expense
  Future<int> updateExpense(Expense expense) async {
    final db = await database;
    return await db.update(
      _tableName,
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  // Delete an expense
  Future<int> deleteExpense(int id) async {
    final db = await database;
    return await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
