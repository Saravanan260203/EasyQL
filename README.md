
EasyQL

EasyQL is a simple and easy-to-use SQLite utility package for Dart and Flutter projects. It provides straightforward methods to create, manipulate, and manage databases, tables, and rows with ease. With support for both programmatic and terminal-based operations, EasyQL offers flexibility for developers to interact with their SQLite databases. This concept is currently under patent application to protect the innovative approach of EasyQL in simplifying SQLite database management.

## Features

• Database Creation: Easily create a database with a single line of code.
• Table Management: Create, update, delete, and truncate tables.
• Data Manipulation: Insert, update, and delete rows in the database.
• Terminal Commands: Run commands directly in the terminal to manage databases and tables.
• Easy Integration: Seamlessly integrate with any Dart or Flutter project.

## Getting started

To add EasyQL to your project, update your pubspec.yaml file:
```dart
dependencies:
  easyql: ^1.0.0
```
Then, run dart pub get to install the package.


## Usage

Creating a Database Programmatically

```dart
import 'package:easyql/easyql.dart';

void main() async {
  // Create database
  var result = await EasyQL.createDatabase();
  print(result);
}
```


Creating a Table Programmatically
```dart
import 'package:easyql/easyql.dart';

void main() async {
  Map<String, String> columns = {
    'id': 'INTEGER PRIMARY KEY AUTOINCREMENT',
    'name': 'TEXT',
    'age': 'INTEGER'
  };

  var result = await EasyQL.createTable('users', columns: columns);
  print(result);
}
```


Inserting Data Programmatically
```dart
import 'package:easyql/easyql.dart';

void main() async {
  Map<String, String> data = {
    'name': 'John Doe',
    'age': '30',
  };

  var result = await EasyQL.insert('users', values: data);
  print(result);
}
```

Updating Data Programmatically

```dart
import 'package:easyql/easyql.dart';

void main() async {
  Map<String, String> data = {
    'name': 'Jane Doe',
  };

  var result = await EasyQL.update('users', values: data, where: "id=1");
  print(result);
}

```



Deleting Data Programmatically
```dart
import 'package:easyql/easyql.dart';

void main() async {
  var result = await EasyQL.delete('users', where: "id=1");
  print(result);
}
```



Truncating a Table Programmatically
```dart
import 'package:easyql/easyql.dart';

void main() async {
  var result = await EasyQL.truncateTable('users');
  print(result);
}
```



Dropping a Table Programmatically
```dart
import 'package:easyql/easyql.dart';

void main() async {
  var result = await EasyQL.dropTable('users');
  print(result);
}
```

Using Terminal Commands

You can also manage your SQLite database from the terminal. Here are some examples:

• Create Table Command
```dart
dart run easyql create table Users with columns id as INTEGER PRIMARY KEY, name as TEXT, email as TEXT
```

Insert Data Command
```dart
dart run easyql insert into table Users values {id: 1, name: 'John', email: 'john@example.com'}
```

Show Table Command
```dart
dart run easyql show table Users
```

Update Data Command
```dart
dart run easyql update table Users values {name: 'Jane'} where {id=1}
```

Delete Data Command
```dart
dart run easyql delete table Users where {id=1}
```

Truncate Table Command
```dart
dart run easyql empty table Users
```

Drop Table Command
```dart
dart run easyql delete table Users
```


## Contributing

If you'd like to contribute to EasyQL, feel free to fork the repository, create a pull request, and help improve this package! Make sure to follow the proper coding conventions and add tests for new features.


## License
EasyQL is licensed under the MIT License.