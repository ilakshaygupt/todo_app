import 'package:flutter/material.dart';
import 'package:todo_app/database.dart';
import 'package:todo_app/todo_tile.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ThemeController themeController;

  final _todo = Hive.box('todo');
  final titleController = TextEditingController();
  // List toDoList = [];
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

  void createNewTask() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Colors.teal, width: 4)),
            backgroundColor: Colors.tealAccent[700],
            title: const Text(
              'Create New Task',
              style: TextStyle(color: Colors.black),
            ),
            content: TextField(
              controller: titleController,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                hintText: 'Enter Task Name',
                hintStyle: const TextStyle(color: Colors.black),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
              const SizedBox(
                width: 80,
              ),
              ElevatedButton(
                onPressed: () {
                  addTask(titleController.text);
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        const Color.fromARGB(159, 36, 146, 135))),
                child: const Text('Add'),
              )
            ],
          );
        });
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
            icon: Obx(() => Icon(
                  color: Colors.black,
                  themeController.isDarkMode.value
                      ? Icons.light_mode
                      : Icons.dark_mode,
                )),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: const Icon(Icons.add),
      ),
      body: db.toDoList.isNotEmpty
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
                    deleteTask: (context) => deleteTask(index));
              },
            )
          : const Center(
              child: Text(
                'No Tasks Added',
                style: TextStyle(fontSize: 30),
              ),
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
