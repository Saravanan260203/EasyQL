import 'package:args/args.dart';
import 'package:easyql/easyql.dart';

void main(List<String> arguments) async {
  final parser = ArgParser()
    ..addCommand('create')
    ..addCommand('insert')
    ..addCommand('show')
    ..addCommand('update')
    ..addCommand('delete')
    ..addCommand('empty')
    ..addCommand('drop');

  final argResults = parser.parse(arguments);

  // Initialize the database
  await EasyQL.createDatabase();

  if (argResults.command == null) {
    print('No command specified');
    return;
  }

  switch (argResults.command!.name) {
    case 'create':
      await _createTable(argResults.command!);
      break;
    case 'insert':
      await _insertRow(argResults.command!);
      break;
    case 'show':
      await _showTable(argResults.command!);
      break;
    case 'update':
      await _updateRow(argResults.command!);
      break;
    case 'delete':
      await _deleteRow(argResults.command!);
      break;
    case 'empty':
      await _emptyTable(argResults.command!);
      break;
    case 'drop':
      await _dropTable(argResults.command!);
      break;
    default:
      print('Unknown command: ${argResults.command!.name}');
  }
}

Future<void> _createTable(ArgResults command) async {
  final tableName = command.rest[0];
  final columnsString = command.rest
      .sublist(1)
      .join(' '); // e.g., 'id as INTEGER PRIMARY KEY, name as TEXT'
  final columns = _parseColumns(columnsString);

  final result = await EasyQL.createTable(tableName, columns: columns);
  print(result['message']);
}

Future<void> _insertRow(ArgResults command) async {
  final tableName = command.rest[0];
  final valuesString =
      command.rest.sublist(1).join(' '); // e.g., 'id:1, name:John'
  final values = _parseValues(valuesString);

  final result = await EasyQL.insertRow(tableName, values: values);
  print(result['message']);
}

Future<void> _showTable(ArgResults command) async {
  final tableName = command.rest[0];
  final result = await EasyQL.showTable(tableName);
  if (result['status']) {
    _printTable(result['data']);
  } else {
    print(result['message']);
  }
}

Future<void> _updateRow(ArgResults command) async {
  final tableName = command.rest[0];
  final valuesString = command.rest[1];
  final whereClause = command.rest[2];

  final values = _parseValues(valuesString);
  final result =
      await EasyQL.updateRow(tableName, values: values, where: whereClause);
  print(result['message']);
}

Future<void> _deleteRow(ArgResults command) async {
  final tableName = command.rest[0];
  final whereClause = command.rest[1];
  final result = await EasyQL.deleteRow(tableName, where: whereClause);
  print(result['message']);
}

Future<void> _emptyTable(ArgResults command) async {
  final tableName = command.rest[0];
  final result = await EasyQL.truncateTable(tableName);
  print(result['message']);
}

Future<void> _dropTable(ArgResults command) async {
  final tableName = command.rest[0];
  final result = await EasyQL.dropTable(tableName);
  print(result['message']);
}

Map<String, String> _parseColumns(String columnsString) {
  final columns = <String, String>{};
  final columnPairs = columnsString.split(',').map((e) => e.trim()).toList();
  for (var column in columnPairs) {
    final parts = column.split(' as ');
    columns[parts[0]] = parts[1];
  }
  return columns;
}

Map<String, dynamic> _parseValues(String valuesString) {
  final values = <String, dynamic>{};
  final keyValuePairs = valuesString.split(',').map((e) => e.trim()).toList();
  for (var pair in keyValuePairs) {
    final parts = pair.split(':');
    values[parts[0]] = parts[1];
  }
  return values;
}

void _printTable(List<Map<String, dynamic>> rows) {
  if (rows.isEmpty) {
    print('No data available.');
    return;
  }

  final columnNames = rows[0].keys;
  final separator = '-' * 50;

  // Print headers
  print(separator);
  print(columnNames.join(' | '));
  print(separator);

  // Print data rows
  for (var row in rows) {
    print(row.values.join(' | '));
  }
  print(separator);
}
