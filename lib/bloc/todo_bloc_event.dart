import 'package:flutter_project/db/todo_item.dart';

abstract class TodoBlocEvent {
  TodoBlocEvent();
}

class AddTodoBlocEvent extends TodoBlocEvent {
  String id;
  String title;
  String description;

  AddTodoBlocEvent(this.id, this.title, this.description);
}

class UpdateTodoBlocEvent extends TodoBlocEvent {
  TodoItem item;
  UpdateTodoBlocEvent(this.item);
}

class DeleteTodoBlocEvent extends TodoBlocEvent {
  TodoItem item;
  DeleteTodoBlocEvent(this.item);
}

class FetchTodoBlocEvent extends TodoBlocEvent {
  FetchTodoBlocEvent();
}