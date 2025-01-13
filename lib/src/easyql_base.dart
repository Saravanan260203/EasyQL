import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// A class to simplify database operations using SQLite.
class EasyQL {
  static late Database _database;

  /// Creates a new database.
  ///
  /// This method initializes the database, creates a new file at the specified path,
  /// and sets up the necessary structure.
  ///
  /// Returns a map with the status and message of the operation.
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

  /// Creates a table in the database.
  ///
  /// [tableName] is the name of the table to be created.
  /// [columns] is a map where the keys are column names and the values are column data types.
  ///
  /// Returns a map with the status and message of the operation.
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

  /// Inserts a row into a specified table.
  ///
  /// [tableName] is the name of the table where the data should be inserted.
  /// [values] is a map of column names and their respective values.
  ///
  /// Returns a map with the status and message of the operation.
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

  /// Fetches all rows from the specified table.
  ///
  /// [tableName] is the name of the table to fetch data from.
  ///
  /// Returns a map with the status, message, and the fetched data.
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

  /// Updates a row in the specified table.
  ///
  /// [tableName] is the name of the table where the row needs to be updated.
  /// [values] is a map of columns and their new values.
  /// [where] is the condition for updating the row(s).
  ///
  /// Returns a map with the status and message of the operation.
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

  /// Deletes rows from the specified table.
  ///
  /// [tableName] is the name of the table from which rows should be deleted.
  /// [where] is the condition for deleting the row(s).
  ///
  /// Returns a map with the status and message of the operation.
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

  /// Truncates a table by deleting all rows.
  ///
  /// [tableName] is the name of the table to be truncated.
  ///
  /// Returns a map with the status and message of the operation.
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

  /// Drops a table from the database.
  ///
  /// [tableName] is the name of the table to be dropped.
  ///
  /// Returns a map with the status and message of the operation.
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
