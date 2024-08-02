import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todoappbloc/api/apiservices.dart';
import 'package:todoappbloc/model/model.dart';
showNameDialog(BuildContext context) {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _taskController = TextEditingController();
   ApiServices apiServices=ApiServices();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Center(child: Text('Add Here')),
        content: Container(
          width: 300.0,
          height: 220.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Add title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _taskController,
                decoration: InputDecoration(
                  labelText: 'Add task',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                maxLines: 5,
              ),
            ],
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () async {
              final String title = _nameController.text.trim();
              final String description = _taskController.text.trim();
              if (title.isNotEmpty && description.isNotEmpty) {
                final Todo newTodo = Todo(
                  title: title,
                  description: description,
                  isCompleted: false,
                );

                try {
                  await apiServices.createTodo(newTodo);
                  Navigator.of(context).pop();
                } catch (e) {
                  if (kDebugMode) {
                    print('Failed to create todo: $e');
                  }
                }
              }
            },
            child: Text('Add', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          ),
        ],
      );
    },
  );
}
