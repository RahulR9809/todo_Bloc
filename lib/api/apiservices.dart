import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:todoappbloc/model/model.dart';

class ApiServices {
  static const String endPoint =
      "https://api.nstack.in/v1/todos?page=1&limit=10";

  Future<List<Todo>> fetchTodos() async {
  const maxRetries=3;
  int retrycount=0;
  while(retrycount<maxRetries){
    try{
final response=await http.get(Uri.parse(endPoint));
if(response.statusCode==200){
  final List<dynamic>data=jsonDecode(response.body)['items'];
  return data.map((json)=>Todo.fromJson(json)).toList();
}
    }catch(e){
log('error fetching data');
    }
    retrycount++;
  }
  return [];
  }

    Future<bool> createTodo(Todo todo) async {
    final response = await http.post(
      Uri.parse(endPoint),
      body: jsonEncode(todo.toJson()),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      return true;
    
    } else {
      log('Failed to create todo: ${response.statusCode}',);
      return false;
    }
  }
}
