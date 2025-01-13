import 'package:easyql/easyql.dart';

void main() async {
  // Create database
  var result = await EasyQL.createDatabase();
  print(result);
}
