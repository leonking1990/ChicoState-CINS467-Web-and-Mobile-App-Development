import 'package:flutter/material.dart';

import 'fireStorage.dart';
import 'task.dart';
import 'ToDoClass.dart';
import 'taskClass.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;
  final String userId = "7CHeNwgCIPbrsLbsyakV";

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  // List to hold CheckableBox widgets
  List<MyToDo> myToDos = [];

  void textSubmit(TextEditingController textEditingController) {
    if (textEditingController.text.isNotEmpty) {
      setState(() {
        myToDos.add(MyToDo(title: textEditingController.text, tasks: []));
      });
      FireStorage.saveToDoList(myToDos, widget.userId);
      Navigator.pop(context);
    }
  }

  void showAddTaskDialog(MyToDo toDo, int index) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
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
                    // Add the task to the specific ToDo
                    toDo.tasks
                        .add(MyTask(name: controller.text, isCompleted: false));
                  });
                  FireStorage.saveToDoList(myToDos, widget.userId);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  void deleteToDo(int index) {
    setState(() {
      myToDos.removeAt(index);
      // If you're using a method to save or update your data, call it here
      FireStorage.saveToDoList(myToDos, widget.userId);
    });
  }

  void deleteTask(List<MyTask> tasks, int taskIndex) {
    setState(() {
      tasks.removeAt(taskIndex);
      FireStorage.saveToDoList(myToDos, widget.userId);
    });
  }

  void deleteToDoDialog(int index, String title) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete: "$title"'),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: const Text('Delete'),
                onPressed: () {
                  deleteToDo(index);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  void showAddDialog() {
    final TextEditingController textEditingController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create a To-Do'),
          content: TextField(
            controller: textEditingController,
            decoration: const InputDecoration(hintText: "To-Do"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                textSubmit(textEditingController);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    FireStorage.loadToDoList().then((toDos) {
      setState(() {
        myToDos = toDos;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My ToDos",
            textAlign: TextAlign
                .center), // This centers the AppBar title but not centering will fix later.
      ),
      body: StreamBuilder<List<MyToDo>>(
        stream: FireStorage().getToDosStream(widget.userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          myToDos = snapshot.data!;
          return ListView.builder(
            itemCount: myToDos.length,
            itemBuilder: (context, index) {
              MyToDo toDo = myToDos[index];
              return Card(
                // Use Card to create a box-like UI for each ToDo Remember this next time!!!!
                margin: const EdgeInsets.all(8.0),
                color: Colors
                    .grey[300]!, // Adding margin around each card for spacing
                child: Column(
                  children: <Widget>[
                    ListTile(
                        title: Text(
                          '${toDo.title}:',
                          textAlign: TextAlign.left,
                        ),
                        contentPadding: const EdgeInsets.only(
                            left: 50.0), // Centered ToDo title
                        trailing: IconButton(
                          icon: const Icon(Icons.add,
                              color: Colors
                                  .green), // Use a plus icon, colored green
                          onPressed: () => showAddTaskDialog(toDo, index),
                        ),
                        onLongPress: () => deleteToDoDialog(index, toDo.title)),
                    ListView.builder(
                      physics:
                          const NeverScrollableScrollPhysics(), // Disables scrolling for the nested ListView
                      shrinkWrap:
                          true, // Necessary for ListView inside another ListView
                      itemCount: toDo.tasks.length,
                      itemBuilder: (context, taskIndex) {
                        // Alternate background color
                        Color bgColor = taskIndex % 2 == 0
                            ? Colors.grey[100]!
                            : Colors.grey[300]!;
                        return Container(
                          color: bgColor,
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(
                                    left: 75.0), // Adjust the padding as needed
                                child: Text('• '), // Bullet point
                              ),
                              Expanded(
                                // Ensure Task widget remaining space
                                child: Task(
                                  task: toDo.tasks[taskIndex],
                                  save: () => FireStorage.saveToDoList(
                                      myToDos, widget.userId),
                                  deleteTask: () =>
                                      deleteTask(toDo.tasks, taskIndex),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddDialog, // to add a new ToDo
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ),
    );
  }
}
