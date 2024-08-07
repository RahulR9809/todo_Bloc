import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:todoappbloc/model/model.dart';

class ApiServices {
  static const String baseUrl = "https://api.nstack.in/v1/todos";

  Future<List<Todo>> fetchTodos({required int page, required int limit}) async {
    const maxRetries = 3;
    int retryCount = 0;
    while (retryCount < maxRetries) {
      try {
        final response = await http.get(Uri.parse('$baseUrl?page=$page&limit=$limit'));
        if (response.statusCode == 200) {
          final List<dynamic> data = jsonDecode(response.body)['items'];
          return data.map((json) => Todo.fromJson(json)).toList();
        }
      } catch (e) {
        log('Error fetching data: $e');
      }
      retryCount++;
    }
    return [];
  }

  Future<bool> createTodo(Todo todo) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      body: jsonEncode(todo.toJson()),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      log('Failed to create todo: ${response.statusCode}');
      return false;
    }
  }
}
