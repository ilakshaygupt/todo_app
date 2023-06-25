import 'package:flutter/material.dart';
import 'package:todo_app/database.dart';
import 'package:todo_app/todo_tile.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:get/get.dart';

var kColorScheme = ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 251, 255, 0), primary: Colors.yellow);

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ThemeController themeController;

  final _todo = Hive.box('todo');
  final titleController = TextEditingController();
  MyDatabase db = MyDatabase();

  @override
  void initState() {
    super.initState();
    if (_todo.isOpen) {
      db.loadData();
    } else {
      db.createIntialData();
    }
    themeController = Get.put(ThemeController());
  }

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateData();
  }

  void addTask(String title) {
    setState(() {
      db.toDoList.add([title, false]);
      titleController.clear();
    });
    db.updateData();
  }

  void deleteTask(int index) {
    final textRemoved = db.toDoList[index];
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateData();
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Item deleted.'),
        action: SnackBarAction(
          textColor: Colors.black,
          backgroundColor: Colors.teal,
          label: 'Undo',
          onPressed: () {
            setState(() {
              db.toDoList.insert(index, textRemoved);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellowAccent,
        title: const Text(
          'Todo App',
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: () {
              themeController.toggleTheme();
            },
            icon: Obx(
              () => Icon(
                color: Colors.black,
                themeController.isDarkMode.value
                    ? Icons.light_mode
                    : Icons.dark_mode,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: db.toDoList.isNotEmpty
                ? ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.fromLTRB(13, 10, 13, 0),
                    itemCount: db.toDoList.length,
                    itemBuilder: (context, index) {
                      return ToDoTile(
                        title: db.toDoList[index][0],
                        isDone: db.toDoList[index][1],
                        onChanged: (value) => checkBoxChanged(value, index),
                        deleteTask: (context) => deleteTask(index),
                      );
                    },
                  )
                : const Center(
                    child: Text(
                      'No Tasks Added',
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: titleController,
                      style: TextStyle(color: Colors.black)),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      filled: true,
                      fillColor: Colors.yellowAccent,
                      hintText: 'Enter Task Name',
                      hintStyle: const TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    addTask(titleController.text);
                    titleController.clear();
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.yellowAccent)),
                  child: const Text(
                    'Add',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ThemeController extends GetxController {
  RxBool isDarkMode = true.obs;

  void toggleTheme() {
    isDarkMode.toggle();
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }
}
