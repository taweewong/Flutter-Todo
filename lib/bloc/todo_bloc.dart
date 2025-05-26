import 'package:bloc/bloc.dart';
import 'package:flutter_project/bloc/todo_bloc_event.dart';
import 'package:flutter_project/bloc/todo_bloc_state.dart';
import 'package:flutter_project/db/todo_item.dart';
import 'package:flutter_project/db/todo_provider.dart';

class TodoBloc extends Bloc<TodoBlocEvent, TodoBlocState> {

  TodoProvider todoProvider = TodoProvider.instance;

  TodoBloc() : super(InitialTodoBlocState()) {

    List<TodoItem> todos = [];

    on<AddTodoBlocEvent>((event, emit) async {
      await todoProvider.insertTodo(
        TodoItem(event.id, event.title, event.description, false)
      );
    });

    on<UpdateTodoBlocEvent>((event, emit) async {
      await todoProvider.updateTodo(event.item);
    });

    on<DeleteTodoBlocEvent>((event, emit) async {
      await todoProvider.deleteTodo(event.item);
    });

    on<FetchTodoBlocEvent>((event, emit) async {
      todos = await todoProvider.fetchTodos();
      emit(TodoListState(todos));
    });
  }
}