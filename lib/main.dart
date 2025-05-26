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
                return MyItem(todoItem);
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

  TodoItem _item;

  MyItem(this._item);

  @override
  State<StatefulWidget> createState() => _MyItemState(_item);
}

class _MyItemState extends State<MyItem> {

  TodoItem _item;

  _MyItemState(this._item);

  TodoProvider todoProvider = TodoProvider.instance;

  void _checked(TodoItem item) async {
    var newItem = TodoItem(item.id, item.title, item.description, !item.done);
    await todoProvider.updateTodo(newItem);
    setState(() {
      _item = newItem;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      background: Container(),
      secondaryBackground: Container(color: Colors.red),
      onDismissed: (direction) {
        todoProvider.deleteTodo(_item);
      },
      child: ListTile(
        title: Text(_item.title),
        subtitle: Text(_item.description),
        leading: Checkbox(
          value: _item.done,
          onChanged: (value) {
            _checked(_item);
          },
        ),
        onTap: () {
          _checked(_item);
        },
      ),
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
