import 'package:flutter/material.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
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
              ),
              TextField(
                  decoration: InputDecoration(
                      labelText: "Description"
                  )
              ),
              SizedBox.fromSize(
                size: Size(16, 16),
              ),
              ElevatedButton(
                  onPressed: () {
                    //TODO: Add todo item
                    Navigator.of(context).pop();
                  },
                  child: Text("Add")
              )
            ],
          ),
        ),
      ),
    );
  }
}
