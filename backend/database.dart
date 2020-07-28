import 'dart:async';

import 'package:flutter/widgets.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void dbc() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  final database = openDatabase(
    
    join(await getDatabasesPath(), 'walletApp_database.db'),
    // When the database is first created, create a table to store expenses.
    onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE expenses(id INTEGER PRIMARY KEY, expenditureReason TEXT,amountOfExpense INTEGER, typeOfExpense TEXT, time TEXT)",
      );
    },
    
    version: 1,
  );

  Future<void> insertExpense(Expense expense) async {
    
    final Database db = await database;

    // Insert the expense into the table. Also specify the
    // `conflictAlgorithm`. In this case, if the same expense is inserted
    // multiple times, it replaces the previous data.
    await db.insert(
      'expenses',
      expense.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Expense>> expenses() async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The expenses.
    final List<Map<String, dynamic>> maps = await db.query('expenses');

    // Convert the List<Map<String, dynamic> into a List<Expense>.
    return List.generate(maps.length, (i) {
      return Expense(
        id: maps[i]['id'],
        expenditureReason: maps[i]['expenditureReason'],
        amountOfExpense: maps[i]['amountOfExpense'],
        typeOfExpense: maps[i]['typeOfExpense'],
        time: maps[i]['time'],
      );
    });
  }

  Future<void> updateExpense(Expense expense) async {
    // Get a reference to the database.
    final db = await database;

    // Update the given data.
    await db.update(
      'expenses',
      expense.toMap(),
      // Ensure that the data has a matching id.
      where: "id = ?",
      // Pass the data id as a whereArg to prevent SQL injection.
      whereArgs: [expense.id],
    );
  }

  Future<void> deleteExpense(int id) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the data from the database.
    await db.delete(
      'expenses',
      
      where: "id = ?",
      
      whereArgs: [id],
    );
  }

  var data1 = Expense(
    id: 0,
    expenditureReason: 'foodforfriends',
    amountOfExpense: 35.89,
    typeOfExpense: 'food',
    time: 'sadasdasd',
  );

  // Insert into the database.
  await insertExpense(data1);

  // Print the list 
  print(await expenses());

  // Update 
  data1 = Expense(
    id: data1.id,
    expenditureReason: data1.expenditureReason,
    amountOfExpense: data1.amountOfExpense + 7,
    typeOfExpense: data1.typeOfExpense,
    time: data1.time,

  );
  await updateExpense(data1);

  // Print updated information.
  print(await expenses());

  // Delete 
  await deleteExpense(data1.id);

  // Print the list (empty).
  print(await expenses());
}

class Expense {
  final int id;
  final String expenditureReason;
  final double amountOfExpense;
  final String typeOfExpense;
  final String time;

  Expense({this.id, this.expenditureReason, this.amountOfExpense,this.typeOfExpense,this.time});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'expenditureReason': expenditureReason,
      'amountOfExpense': amountOfExpense,
      'typeOfExpense': typeOfExpense,
      'time': time   
       };
  }

  // Implement toString to make it easier to see information about
  // each data when using the print statement.
  @override
  String toString() {
    return 'Expense{id: $id, expenditureReason: $expenditureReason, amountOfExpense : $amountOfExpense,typeOfExpense : $typeOfExpense,time : $time}';
  }}