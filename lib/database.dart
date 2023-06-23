import 'package:hive_flutter/hive_flutter.dart';

class MyDatabase {
  List toDoList = [
    ['intital data', false],
  ];

  final _todo = Hive.box('todo');

  void createIntialData() {
    toDoList = _todo.get('todo') ?? [];
  }

  void loadData() {
    toDoList = _todo.get('todo') ?? [];
  }

  void updateData() {
    _todo.put('todo', toDoList);
  }
}
