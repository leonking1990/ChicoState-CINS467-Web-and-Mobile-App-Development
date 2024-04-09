// I plan to work on this later on my own time; current not being used for assignment.

import 'package:flutter/material.dart';
import 'task.dart'; 
import 'ToDoClass.dart';

typedef AddTaskCallback = Function(ToDo toDo);

class MyToDo extends StatefulWidget {
  final ToDo toDo;
  final AddTaskCallback showAddTaskDialog;

  const MyToDo({Key? key, required this.toDo, required this.showAddTaskDialog}) : super(key: key);

  @override
  MyToDoState createState() => MyToDoState();
}

class MyToDoState extends State<MyToDo> {

void showAddTaskDialog() {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return 
        AlertDialog(
          title: const Text('Add New Task'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: "Enter task name"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  setState(() {
                    widget.toDo.tasks.add(
                        controller.text); // Add the task to the specific ToDo
                  });
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap:  showAddTaskDialog, //widget.showAddTaskDialog(widget.toDo), *** commented out for debugging ***
          child: Text(widget.toDo.title),
        ),
      ),
      body: ListView.builder(
        itemCount: widget.toDo.tasks.length,
        itemBuilder: (context, index) {
          return Task(task: widget.toDo.tasks[index]);
        },
      ),
    );
  }
}
