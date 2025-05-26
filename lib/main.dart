import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project/add_todo_page.dart';
import 'package:flutter_project/bloc/todo_bloc.dart';
import 'package:flutter_project/bloc/todo_bloc_event.dart';
import 'package:flutter_project/db/todo_provider.dart';
import 'package:flutter_project/pokemon.dart';
import 'package:google_fonts/google_fonts.dart';

import 'bloc/todo_bloc_state.dart';
import 'db/todo_item.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [BlocProvider(create: (context) => TodoBloc())],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            appBarTheme: const AppBarTheme(foregroundColor: Color(0xFFFFFFFF)),
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
            textTheme: GoogleFonts.kanitTextTheme(),
          ),
          home: const MyHomePage(title: 'Flutter Demo Home Page'),
        )
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
      body: BlocBuilder<TodoBloc, TodoBlocState>(
          builder: (context, state) {
            if (state is InitialTodoBlocState) {
              context.read<TodoBloc>().add(FetchTodoBlocEvent());
            }

            if (state is TodoListState) {
              var todos = state.todos;
              return ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    var todoItem = todos[index];
                    return MyItem(todoItem);
                  }
              );
            }

            return Center(child: CircularProgressIndicator());
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
  State<StatefulWidget> createState() => _MyItemState();
}

class _MyItemState extends State<MyItem> {

  void _checked(TodoItem item) async {
    var newItem = TodoItem(item.id, item.title, item.description, !item.done);
    context.read<TodoBloc>().add(UpdateTodoBlocEvent(newItem));
    context.read<TodoBloc>().add(FetchTodoBlocEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoBloc, TodoBlocState>(
        builder: (context, state) {
          var item = widget._item;
          return Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.endToStart,
            background: Container(),
            secondaryBackground: Container(color: Colors.red),
            onDismissed: (direction) {
              context.read<TodoBloc>().add(DeleteTodoBlocEvent(item));
              context.read<TodoBloc>().add(FetchTodoBlocEvent());
            },
            child: ListTile(
              title: Text(item.title),
              subtitle: Text(item.description),
              leading: Checkbox(
                value: item.done,
                onChanged: (value) {
                  _checked(item);
                },
              ),
              onTap: () {
                _checked(item);
              },
            ),
          );
        }
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
