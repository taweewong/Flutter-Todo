class TodoItem {
  final String id;
  final String title;
  final String description;
  final bool done;

  TodoItem(this.id, this.title, this.description, this.done);

  factory TodoItem.fromMap(Map map) {
    return TodoItem(
      map["id"],
      map["title"],
      map["description"],
      map["done"] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "done": done ? 1 : 0,
    };
  }
}