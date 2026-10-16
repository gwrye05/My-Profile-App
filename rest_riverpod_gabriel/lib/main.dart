import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

// Represents one TODO from the REST API.
class Todo {
  final int id;
  final String title;
  final bool completed;

  Todo({required this.id, required this.title, required this.completed});

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'],
      completed: json['completed'],
    );
  }
}

// Fetch the TODO list from the REST API.
final todosProvider = FutureProvider<List<Todo>>((ref) async {
  final url = Uri.parse('https://jsonplaceholder.typicode.com/todos');

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);

    return data.map((item) {
      return Todo.fromJson(item);
    }).toList();
  } else {
    throw Exception('Failed to load TODOs');
  }
});

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Riverpod Todos',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

// First screen.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to the Flutter Todo App!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TodosPage()),
                );
              },
              child: const Text('Load Todos'),
            ),
          ],
        ),
      ),
    );
  }
}

// Second screen.
class TodosPage extends ConsumerWidget {
  const TodosPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todosAsync = ref.watch(todosProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: todosAsync.when(
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },
        error: (error, stackTrace) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Could not load TODOs.'),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(todosProvider);
                  },
                  child: const Text('Try Again'),
                ),
              ],
            ),
          );
        },
        data: (todos) {
          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];

              return TodoTile(todo: todo);
            },
          );
        },
      ),
    );
  }
}

// Displays one TODO with a checkbox and strikethrough.
class TodoTile extends StatefulWidget {
  final Todo todo;

  const TodoTile({super.key, required this.todo});

  @override
  State<TodoTile> createState() => _TodoTileState();
}

class _TodoTileState extends State<TodoTile> {
  late bool isCompleted;

  @override
  void initState() {
    super.initState();
    isCompleted = widget.todo.completed;
  }

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: isCompleted,
      controlAffinity: ListTileControlAffinity.leading,
      title: Text(
        widget.todo.title,
        style: TextStyle(
          decoration: isCompleted
              ? TextDecoration.lineThrough
              : TextDecoration.none,
        ),
      ),
      onChanged: (value) {
        setState(() {
          isCompleted = value ?? false;
        });
      },
    );
  }
}
