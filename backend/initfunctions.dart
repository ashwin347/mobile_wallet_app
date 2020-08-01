//Todo : this file contains functions required to be executed during initial launch

import 'dart:async';
import 'dart:wasm';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


class Expense {
  final int id;
  final Float amountOfExpense;
  final String typeOfExpense;
  final String time;


  Expense({this.id,this.amountOfExpense,this.typeOfExpense, this.time});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amountOfExpense': amountOfExpense,
      'typeOfExpense': typeOfExpense,
      'time' : time,
    };
  }

}

initDB() async {
  
  final Future<Database> database = openDatabase(
  
  join(await getDatabasesPath(), 'wallet_database.db'),
  onCreate: (db, version) {
    return db.execute(
      "CREATE TABLE Expense(id INTEGER PRIMARY KEY AUTO_INCRIMENT, amountOfExpense FLOAT, typeOfExpense TEXT, time TEXT)",
    );
  },
    version: 1,
);
} 





initcheck(){
  //TOdo : function to check whether user is logged in and user information is filled
  //Todo : return true or false
  return true;
}