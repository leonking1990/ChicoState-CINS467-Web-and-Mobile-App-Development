class ToDo {
  String title;
  List<String> tasks;

  ToDo({required this.title, required this.tasks});

  // Convert a ToDo object into a Map
  Map<String, dynamic> toJson() => {
        'title': title,
        'tasks': tasks,
      };

  // Create a ToDo object from a map
  factory ToDo.fromJson(Map<String, dynamic> json) => ToDo(
        title: json['title'],
        tasks: List<String>.from(json['tasks']),
      );
}