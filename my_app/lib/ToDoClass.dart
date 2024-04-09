import 'taskClass.dart';

class MyToDo {
  String title;
  List<MyTask> tasks;

  MyToDo({required this.title, required this.tasks});

  // Convert a ToDo object into a Map
  Map<String, dynamic> toJson() => {
        'title': title,
        // Convert each MyTask object in the tasks list to a map
        'tasks': tasks.map((task) => task.toJson()).toList(),
      };

  // Create a ToDo object from a map
  factory MyToDo.fromJson(Map<String, dynamic> json) => MyToDo(
        title: json['title'],
        // Ensure that json['tasks'] is a list and convert each item in the list using MyTask.fromJson
        tasks: json['tasks'] != null
            ? List<MyTask>.from(
                json['tasks'].map((taskJson) => MyTask.fromJson(taskJson)))
            : [],
      );
}
