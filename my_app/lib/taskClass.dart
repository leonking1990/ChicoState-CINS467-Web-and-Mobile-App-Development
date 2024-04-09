class MyTask {
  String name;
  bool isCompleted;

  MyTask({required this.name, required this.isCompleted});

  Map<String, dynamic> toJson() => {
        'name': name,
        'isCompleted': isCompleted,
      };

  factory MyTask.fromJson(Map<String, dynamic> json) => MyTask(
        name: json['name'],
        isCompleted: json['isCompleted'],
      );
  // Convert a ToDo object into a Map
  void changeIsCompleted() {
    isCompleted = !isCompleted;
  }
}
