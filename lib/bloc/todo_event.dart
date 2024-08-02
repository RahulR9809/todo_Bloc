part of 'todo_bloc.dart';

@immutable
sealed class TodoEvent {}

class GetTodoEvents extends TodoEvent {}

class AddToDoEvents extends TodoEvent {
  final Todo toDo;
  AddToDoEvents({required this.toDo});
}
