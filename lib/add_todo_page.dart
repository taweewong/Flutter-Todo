import 'package:flutter/material.dart';
import 'package:flutter_project/db/todo_item.dart';
import 'package:uuid/uuid.dart';

import 'db/todo_provider.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {

  TodoProvider todoProvider = TodoProvider.instance;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Add Todo"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: "Title"
                ),
                controller: _titleController,
              ),
              SizedBox.fromSize(
                size: Size(16, 16),
              ),
              TextField(
                decoration: InputDecoration(
                    labelText: "Description"
                ),
                controller: _descController,
              ),
              SizedBox.fromSize(
                size: Size(16, 16),
              ),
              ElevatedButton(
                  onPressed: () async {
                    var todoItem = TodoItem(
                      Uuid().v4(),
                      _titleController.text,
                      _descController.text,
                      false
                    );
                    await todoProvider.insertTodo(todoItem);
                    if (!mounted) return;
                    closePage();
                  },
                  child: Text("Add")
              )
            ],
          ),
        ),
      ),
    );
  }

  void closePage() {
    Navigator.of(context).pop();
  }
}
