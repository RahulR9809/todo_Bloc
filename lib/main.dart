import 'package:flutter/material.dart';
import 'package:todoappbloc/api/apiservices.dart';
import 'package:todoappbloc/bloc/todo_bloc.dart';
import 'package:todoappbloc/services/home.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoBloc(ApiServices())..add(GetTodoEvents()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}
