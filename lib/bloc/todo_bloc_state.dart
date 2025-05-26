import '../db/todo_item.dart';

abstract class TodoBlocState {
  TodoBlocState();
}

class InitialTodoBlocState extends TodoBlocState {

}

class TodoListState extends TodoBlocState {
  List<TodoItem> todos;

  TodoListState(this.todos);
}
