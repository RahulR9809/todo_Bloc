import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:todoappbloc/api/apiservices.dart';
import 'package:todoappbloc/model/model.dart';
import 'package:todoappbloc/services/add.dart';
import 'package:todoappbloc/bloc/todo_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'TODO APP',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Incomplete'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        body: BlocProvider(
          create: (context) => TodoBloc(ApiServices())..add(GetTodoEvents()),
          child: BlocBuilder<TodoBloc, ToDoState>(
            builder: (context, state) {
              if (state is LoadedToDo) {
                final todos = state.todoList;
                final completedTodos = todos.where((todo) => todo.isCompleted).toList();
                final incompleteTodos = todos.where((todo) => !todo.isCompleted).toList();
                return TabBarView(
                  children: [
                    _buildTodoList(context, incompleteTodos, false),
                    _buildTodoList(context, completedTodos, true),
                  ],
                );
              } else {
                return const Center(child: CircularProgressIndicator()); // Empty container for other states
              }
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showNameDialog(context);
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.blueAccent,
          child:  const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildTodoList(BuildContext context, List<Todo> todos, bool isCompleted) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification is ScrollEndNotification &&
            scrollNotification.metrics.extentAfter == 0) {
          context.read<TodoBloc>().add(LoadMoreTodos());
        }
        return false;
      },
      child: AnimationLimiter(
        child: ListView.builder(
          itemCount: todos.length,
          itemBuilder: (context, index) {
            final todo = todos[index];
            return buildTodoItem(context, todo, index, isCompleted);
          },
        ),
      ),
    );
  }

  Widget buildTodoItem(BuildContext context, Todo todo, int index, bool isCompleted) {
    return AnimationConfiguration.staggeredList(
      position: index,
      delay: const Duration(milliseconds: 100),
      child: FadeInAnimation(
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeInOut,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFE6E0FF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          todo.title,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (todo.description.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        todo.description,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          // Handle expand/collapse logic here
                        },
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: todo.isCompleted,
                            onChanged: (bool? value) {
                              context.read<TodoBloc>().add(
                                UpdateToDoEvent(
                                  todo.copyWith(
                                    isCompleted: value!,
                                  ),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              // Handle delete via BLoC
                              // context.read<TodoBloc>().add(
                              //     DeleteToDoEvents(todo));
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
