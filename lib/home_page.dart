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
  final searchController = TextEditingController();
  MyDatabase db = MyDatabase();
  List<dynamic> visibleTasks = [];
  int toggleIndex = 0;

  @override
  void initState() {
    super.initState();
    if (_todo.isOpen) {
      db.loadData();
    } else {
      db.createInitialData();
    }
    themeController = Get.put(ThemeController());
    visibleTasks = db.toDoList;
    visibleTasks.sort((a, b) {
      if (a[1] && !b[1]) {
        return 1;
      } else if (!a[1] && b[1]) {
        return -1;
      } else {
        return 0;
      }
    });
  }

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      visibleTasks[index][1] = !visibleTasks[index][1];
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        if (toggleIndex == 2) {
          visibleTasks.removeAt(index);
          visibleTasks.sort((a, b) {
            if (a[1] && !b[1]) {
              return 1;
            } else if (!a[1] && b[1]) {
              return -1;
            } else {
              return 0;
            }
          });
        } else {
          visibleTasks.sort((a, b) {
            if (a[1] && !b[1]) {
              return 1;
            } else if (!a[1] && b[1]) {
              return -1;
            } else {
              return 0;
            }
          });
        }
      });
      db.updateData();
    });
  }

  void addTask(String title) {
    setState(() {
      visibleTasks.add([title, false]);
      titleController.clear();
    });
    db.updateData();
  }

  void deleteTask(int index) {
    final textRemoved = visibleTasks[index];
    setState(() {
      visibleTasks.removeAt(index);
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
              visibleTasks.insert(index, textRemoved);
            });
          },
        ),
      ),
    );
  }

  void searchTasks(String query) {
    setState(() {
      if (query.isNotEmpty) {
        visibleTasks = db.toDoList
            .where((task) =>
                task[0].toString().toLowerCase().contains(query.toLowerCase()))
            .toList();
      } else {
        visibleTasks = db.toDoList;
      }
    });
  }

  void toggleTaskList() {
    setState(() {
      toggleIndex = (toggleIndex + 1) % 3;
      if (toggleIndex == 0) {
        visibleTasks = db.toDoList;
      } else if (toggleIndex == 1) {
        visibleTasks = db.getIncompleteItems();
      } else {
        visibleTasks = db.getCompleteItems();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Todo App',
        ),
        actions: [
          IconButton(
            onPressed: () {
              themeController.toggleTheme();
            },
            icon: Obx(
              () => Icon(
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    onChanged: searchTasks,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      filled: true,
                      hintText: 'Search Tasks',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: IconButton(
                    onPressed: toggleTaskList,
                    icon: Icon(
                      toggleIndex == 0
                          ? Icons.list
                          : toggleIndex == 1
                              ? Icons.check_box_outline_blank
                              : Icons.check_box,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: visibleTasks.isNotEmpty
                ? ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.fromLTRB(13, 10, 13, 0),
                    itemCount: visibleTasks.length,
                    itemBuilder: (context, index) {
                      return ToDoTile(
                        title: visibleTasks[index][0],
                        isDone: visibleTasks[index][1],
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
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      filled: true,
                      hintText: 'Enter Task Name',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    if (titleController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter a task name.'),
                        ),
                      );
                      return;
                    } else if (titleController.text.length > 20) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Task name should be less than 20 characters.'),
                        ),
                      );
                      return;
                    } else {
                      addTask(titleController.text);
                      titleController.clear();
                    }
                  },
                  child: Text(
                    'Add',
                    style: TextStyle(
                        color: Theme.of(context).textTheme.titleLarge?.color),
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
