import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project/bloc/todo_bloc_event.dart';
import 'package:flutter_project/bloc/todo_bloc_state.dart';
import 'package:uuid/uuid.dart';

import 'bloc/todo_bloc.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {

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
              BlocBuilder<TodoBloc, TodoBlocState>(builder: (context, state) {
                return ElevatedButton(
                    onPressed: () async {
                      context.read<TodoBloc>().add(
                          AddTodoBlocEvent(
                            Uuid().v4(),
                            _titleController.text,
                            _descController.text,
                          ));
                      context.read<TodoBloc>().add(FetchTodoBlocEvent());
                      if (!mounted) return;
                      closePage();
                    },
                    child: Text("Add")
                );
              })
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
