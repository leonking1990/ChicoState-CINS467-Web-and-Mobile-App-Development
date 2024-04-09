import 'package:flutter/material.dart';

class Task extends StatefulWidget {
  final String task;

  const Task({Key? key, required this.task}) : super(key: key);

  @override
  _TaskState createState() => _TaskState();
}

class _TaskState extends State<Task> {
  bool isChecked = false;

  void _toggleChecked() {
    setState(() {
      isChecked = !isChecked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _toggleChecked, // Handle tap on the entire widget
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            // Wrap your Text widget with Expanded for alignment
            child: Text(
              widget.task,
              textAlign: TextAlign.center, 
              style: const TextStyle(
                  // Adding styling here later own time not part of assignment.
                  ),
            ),
          ),
          SizedBox(width: 10), // Add some space between the text and the box
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black), // Box border
              color: isChecked
                  ? Colors.green
                  : Colors.transparent, // Fill the box if checked
            ),
            width: 24,
            height: 24,
            child: isChecked
                ? Icon(Icons.check, size: 20, color: Colors.white)
                : null, // To show check mark if checked
          ),
        ],
      ),
    );
  }
}
