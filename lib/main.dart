import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_project/add_todo_page.dart';
import 'package:http/http.dart' as http;

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

  @override
  void initState() {
    fetchApi();
    super.initState();
  }

  Future<void> fetchApi() async {
    var url = Uri.https('pokeapi.co', '/api/v2/pokemon');
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  void _onFabClicked() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => AddTodoPage())
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: 20,
        itemBuilder: (context, index) {
          return MyItem();
        },
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
  const MyItem({super.key});

  @override
  State<StatefulWidget> createState() => MyItemState();
}

class MyItemState extends State<MyItem> {
  bool _isChecked = false;

  void _checked() {
    setState(() {
      _isChecked = !_isChecked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("title"),
      subtitle: Text("description"),
      leading: Checkbox(value: _isChecked, onChanged: (value) {
        _checked();
      }),
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
        Checkbox(value: _isChecked, onChanged: (value) {
          _checked();
        }),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("title"),
            Text("description"),
            SizedBox(height: 8),
          ],
        ),
      ],
    );
  }
}
