import 'package:flutter/material.dart';
import 'taskClass.dart';

class Task extends StatefulWidget {
  final MyTask task;
  final Function() save, deleteTask;

  Task(
      {Key? key,
      required this.task,
      required this.save,
      required this.deleteTask})
      : super(key: key);

  @override
  _TaskState createState() => _TaskState();
}

class _TaskState extends State<Task> {
  void _toggleChecked() {
    setState(() {
      widget.task.changeIsCompleted();
    });
    widget.save();
  }

  void showDeleteTaskDialog(String name) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete: "$name"'),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: const Text('Delete'),
                onPressed: () => {widget.deleteTask(), Navigator.pop(context)},
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _toggleChecked,
      onLongPress: () => showDeleteTaskDialog(widget.task
          .name), // Assuming this is correctly defined to show a dialog for deletion
      child: Padding(
        // Padding instead of SizedBox for better control
        padding: const EdgeInsets.all(8.0), // Adjust padding as needed
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              // The Expanded widget allows the text to fill the row's width
              child: Text(
                widget.task.name,
                // Applying text style conditionally based on the task's completion status
                style: TextStyle(
                  fontSize: 15, // Increase the font size
                  decoration: widget.task.isCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
            ),
            // Consider adding an Icon or another widget here if needed
          ],
        ),
      ),
    );
  }
}
