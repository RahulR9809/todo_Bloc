import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todoappbloc/api/apiservices.dart';
import 'package:todoappbloc/model/model.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, ToDoState> {
  ApiServices apiServices=ApiServices();
  TodoBloc(this.apiServices) : super(InitialToDoState()) {
   on<TodoEvent>(fetchInitialToDoListEvent);
  }

Future<void> fetchInitialToDoListEvent(
TodoEvent event,Emitter<ToDoState>emit
)async{
try{
  final toDoList=await apiServices.fetchTodos();
  emit(LoadedToDo(toDoList));
}catch(e){
  emit(ErrorToDoState('Fetching data'));
}
}

Future<void>addToDoEvents(
  AddToDoEvents event, Emitter<ToDoState>emit
)async{
try{
  final success=await apiServices.createTodo(event.toDo);
  if(success){
    emit(TodoAdded());
  }
  }catch(e){
    log('failed to add todo');
  }
}
}

  

