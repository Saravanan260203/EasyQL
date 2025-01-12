library easyql;

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class EasyQL {
  static late Database _database;

  // Initialize the database
  static Future<Map<String, dynamic>> createDatabase() async {
    try {
      String path = join(await getDatabasesPath(), 'easyql.db');
      _database =
          await openDatabase(path, version: 1, onCreate: (db, version) async {
        print("Database created");
      });
      return {"status": true, "message": "Database created successfully."};
    } catch (e) {
      return {"status": false, "message": "Error creating database: $e"};
    }
  }

  // Create a table
  static Future<Map<String, dynamic>> createTable(String tableName,
      {required Map<String, String> columns}) async {
    try {
      String columnDefs =
          columns.entries.map((e) => '${e.key} ${e.value}').join(', ');
      String query = 'CREATE TABLE IF NOT EXISTS $tableName ($columnDefs)';
      await _database.execute(query);
      return {
        "status": true,
        "message": "Table $tableName created successfully."
      };
    } catch (e) {
      return {
        "status": false,
        "message": "Error creating table $tableName: $e"
      };
    }
  }

  // Insert a row
  static Future<Map<String, dynamic>> insertRow(String tableName,
      {required Map<String, dynamic> values}) async {
    try {
      await _database.insert(tableName, values);
      return {
        "status": true,
        "message": "Row inserted into $tableName successfully."
      };
    } catch (e) {
      return {
        "status": false,
        "message": "Error inserting row into $tableName: $e"
      };
    }
  }

  // Show all rows
  static Future<Map<String, dynamic>> showTable(String tableName) async {
    try {
      List<Map<String, dynamic>> result = await _database.query(tableName);
      return {
        "status": true,
        "message": "Rows fetched successfully.",
        "data": result
      };
    } catch (e) {
      return {
        "status": false,
        "message": "Error fetching rows from $tableName: $e"
      };
    }
  }

  // Update a row
  static Future<Map<String, dynamic>> updateRow(String tableName,
      {required Map<String, dynamic> values, required String where}) async {
    try {
      int count = await _database.update(tableName, values, where: where);
      return {
        "status": true,
        "message": "$count row(s) updated in $tableName where $where."
      };
    } catch (e) {
      return {
        "status": false,
        "message": "Error updating rows in $tableName: $e"
      };
    }
  }

  // Delete rows
  static Future<Map<String, dynamic>> deleteRow(String tableName,
      {required String where}) async {
    try {
      int count = await _database.delete(tableName, where: where);
      return {
        "status": true,
        "message": "$count row(s) deleted from $tableName where $where."
      };
    } catch (e) {
      return {
        "status": false,
        "message": "Error deleting rows from $tableName: $e"
      };
    }
  }

  // Truncate a table
  static Future<Map<String, dynamic>> truncateTable(String tableName) async {
    try {
      await _database.execute('DELETE FROM $tableName');
      return {
        "status": true,
        "message": "All rows deleted from $tableName successfully."
      };
    } catch (e) {
      return {
        "status": false,
        "message": "Error truncating table $tableName: $e"
      };
    }
  }

  // Drop a table
  static Future<Map<String, dynamic>> dropTable(String tableName) async {
    try {
      await _database.execute('DROP TABLE IF EXISTS $tableName');
      return {
        "status": true,
        "message": "Table $tableName dropped successfully."
      };
    } catch (e) {
      return {
        "status": false,
        "message": "Error dropping table $tableName: $e"
      };
    }
  }
}
