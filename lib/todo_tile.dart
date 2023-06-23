import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ToDoTile extends StatelessWidget {
  final String title;
  final bool isDone;
  Function(bool?)? onChanged;
  Function(BuildContext)? deleteTask;

  ToDoTile({
    Key? key,
    required this.title,
    required this.isDone,
    required this.onChanged,
    required this.deleteTask,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Dismissible(
        key: Key(title),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
        ),
        onDismissed: (direction) {
          deleteTask?.call(context); //invokes if it is not null
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.yellow,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, 2),
                blurRadius: 4.0,
              )
            ],
          ),
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Checkbox(
                value: isDone,
                onChanged: onChanged,
                activeColor: Colors.black,
              ),
              Text(
                title,
                style: TextStyle(
                  decoration:
                      isDone ? TextDecoration.lineThrough : TextDecoration.none,
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
