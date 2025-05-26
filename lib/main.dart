import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_project/add_todo_page.dart';
import 'package:flutter_project/db/todo_provider.dart';
import 'package:flutter_project/pokemon.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import 'db/todo_item.dart';
import 'model/pokemon_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(foregroundColor: Color(0xFFFFFFFF)),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        textTheme: GoogleFonts.kanitTextTheme(),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  TodoProvider todoProvider = TodoProvider.instance;

  void _onFabClicked() {
    Navigator.of(
      context,
    )
    .push(MaterialPageRoute(builder: (context) => AddTodoPage()))
    .then((value) {
      setState(() {});
    });
  }

  void _onPokemonActionClicked() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => PokemonPage()));
  }

  Future<List<TodoItem>> _fetchTodos() async {
    return await todoProvider.fetchTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            onPressed: _onPokemonActionClicked,
            icon: Icon(Icons.category),
            tooltip: 'Pokemon',
          ),
        ],
      ),
      body: FutureBuilder<List<TodoItem>>(
        future: _fetchTodos(),
        initialData: [],
        builder: (BuildContext context, AsyncSnapshot<List<TodoItem>> snapshot) {
          print("======> ${snapshot.data?.length}");
          if (snapshot.hasData) {
            List<TodoItem> todos = snapshot.data ?? [];
            return ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                var todoItem = todos[index];
                return MyItem(
                  todoItem.title,
                  todoItem.description,
                  todoItem.done
                );
              });
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onFabClicked,
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class MyItem extends StatefulWidget {

  String title;
  String description;
  bool isChecked;

  MyItem(this.title, this.description, this.isChecked);

  @override
  State<StatefulWidget> createState() => MyItemState(title, description, isChecked);
}

class MyItemState extends State<MyItem> {
  String _title;
  String _description;
  bool _isChecked = false;

  MyItemState(this._title, this._description, this._isChecked);

  void _checked() {
    setState(() {
      _isChecked = !_isChecked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(_title),
      subtitle: Text(_description),
      leading: Checkbox(
        value: _isChecked,
        onChanged: (value) {
          _checked();
        },
      ),
      onTap: () {
        _checked();
      },
    );
  }
}

class MyItemOldState extends State<MyItem> {
  bool _isChecked = false;

  void _checked() {
    setState(() {
      _isChecked = !_isChecked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: _isChecked,
          onChanged: (value) {
            _checked();
          },
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text("title"), Text("description"), SizedBox(height: 8)],
        ),
      ],
    );
  }
}
