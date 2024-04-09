import 'package:flutter/material.dart';
import 'task.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ToDoClass.dart';
import 'dart:convert'; // Import dart:convert to use jsonEncode and jsonDecode for save

Future<void> saveToDoList(List<ToDo> toDoList) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  // specify the type of maps for JSON serialization
  List<Map<String, dynamic>> jsonList =
      toDoList.map((toDo) => toDo.toJson()).toList();
  String serializedToDoList = jsonEncode(jsonList);
  await prefs.setString('toDoList', serializedToDoList);
}

Future<List<ToDo>> loadToDoList() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? serializedToDoList = prefs.getString('toDoList');
  if (serializedToDoList != null) {
    // type casting for JSON deserialization
    List<dynamic> jsonList = jsonDecode(serializedToDoList);
    List<ToDo> toDoList = jsonList
        .map<ToDo>((json) => ToDo.fromJson(json as Map<String, dynamic>))
        .toList();
    return toDoList;
  } else {
    return [];
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  // List to hold CheckableBox widgets
  List<ToDo> myToDos = [];

  void textSubmit(TextEditingController textEditingController) {
    if (textEditingController.text.isNotEmpty) {
      setState(() {
        myToDos.add(ToDo(title: textEditingController.text, tasks: []));
        saveToDoList(myToDos);
      });
      Navigator.pop(context);
    }
  }

  void showAddTaskDialog(ToDo toDo) {
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
                    toDo.tasks.add(
                        controller.text); // Add the task to the specific ToDo
                    saveToDoList(myToDos);
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
    loadToDoList().then((loadedToDos) {
      setState(() {
        myToDos = loadedToDos;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My ToDos",
            textAlign: TextAlign.center), // This centers the AppBar title but not centering will fix later.
      ),
      body: ListView.builder(
        itemCount: myToDos.length,
        itemBuilder: (context, index) {
          ToDo toDo = myToDos[index];
          return Card(
            // Use Card to create a box-like UI for each ToDo Remember this next time!!!!
            margin:
                EdgeInsets.all(8.0), // Adding margin around each card for spacing
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text('${toDo.title}:',
                      textAlign: TextAlign.left), // Centered ToDo title
                  onTap: () => showAddTaskDialog(toDo),
                ),
                ListView.builder(
                  physics:
                      NeverScrollableScrollPhysics(), // Disables scrolling for the nested ListView
                  shrinkWrap:
                      true, // Necessary for ListView inside another ListView
                  itemCount: toDo.tasks.length,
                  itemBuilder: (context, taskIndex) {
                    return Task(task: toDo.tasks[taskIndex]);
                  
                  },
                ),
              ],
            ),
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
