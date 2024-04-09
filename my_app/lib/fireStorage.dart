import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'ToDoClass.dart';

class FireStorage {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> saveToDoList(List<MyToDo> toDoList, String userId) async {
    final CollectionReference firestore =
        FirebaseFirestore.instance.collection('toDoList');
    // specify the type of maps for JSON serialization
    List<Map<String, dynamic>> jsonList =
        toDoList.map((toDo) => toDo.toJson()).toList();
    firestore.doc(userId).set({'toDoList': jsonList}).then((value) {
      if (kDebugMode) {
        print('update successful');
      }
    }).catchError((error) {
      if (kDebugMode) {
        print('write error: $error');
      }
    });
  }

  static Future<List<MyToDo>> loadToDoList() async {
    final CollectionReference firestore =
        FirebaseFirestore.instance.collection('toDoList');
    String userId = "7CHeNwgCIPbrsLbsyakV";
    DocumentSnapshot snapshot = await firestore.doc(userId).get();
    if (snapshot.exists && snapshot.data() != null) {
      List<dynamic> jsonList = snapshot.get('toDoList');
      List<MyToDo> toDoList = jsonList
          .map<MyToDo>((json) => MyToDo.fromJson(json as Map<String, dynamic>))
          .toList();
      return toDoList;
    } else {
      return [];
    }
  }

  Stream<List<MyToDo>> getToDosStream(String userId) {
    return _firestore
        .collection('toDoList')
        .doc(userId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        List<dynamic> jsonList = snapshot.get('toDoList') ?? [];
        return jsonList.map((json) => MyToDo.fromJson(json)).toList();
      } else {
        return <MyToDo>[];
      }
    });
  }
}

class ToDo {
}
