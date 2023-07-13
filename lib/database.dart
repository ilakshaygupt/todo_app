import 'package:hive_flutter/hive_flutter.dart';

class MyDatabase {
  List toDoList = [
    ['intital data', false],
  ];

  final _todo = Hive.box('todo');

  void createInitialData() {
    toDoList = _todo.get('todo') ?? [];
  }

  void loadData() {
    toDoList = _todo.get('todo') ?? [];
  }

  void updateData() {
    _todo.put('todo', toDoList);
  }

  List<dynamic> getCompleteItems() {
    List<dynamic> incompleteItems = List.from(toDoList);
    incompleteItems.removeWhere((element) => element[1] == true);
    return incompleteItems;
  }

  List<dynamic> getIncompleteItems() {
    List<dynamic> completeItems = List.from(toDoList);
    completeItems.removeWhere((element) => element[1] == false);
    return completeItems;
  }
}
