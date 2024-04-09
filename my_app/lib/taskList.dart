// I plan to work on this later on my own time; current not being used for assignment.

import 'package:flutter/material.dart';

class MyTasks extends StatefulWidget {
  final String task;

  const MyTasks({Key? key, required this.task}) : super(key: key);

  @override
  _MyTasksState createState() => _MyTasksState();
}

class _MyTasksState extends State<MyTasks> {
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
          Text(widget.task), // Display the text
          SizedBox(width: 10), // Add some space between the text and the box
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black), // Box border
              color: isChecked ? Colors.green : Colors.transparent, // Fill the box if checked
            ),
            width: 24, // Box width
            height: 24, // Box height
            child: isChecked ? Icon(Icons.check, size: 20, color: Colors.white) : null, // to show checkmark if checked
          ),
        ],
      ),
    );
  }
}