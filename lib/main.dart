import 'package:flutter/material.dart';
import 'supabase.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SupabaseConfig.initialize();

  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List with Supabase',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TodoListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final TextEditingController _todoController = TextEditingController();
  List<Map<String, dynamic>> _todos = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchTodos();
  }

  Future<void> _fetchTodos() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await SupabaseConfig.client
          .from('todos')
          .select()
          .order('created_at', ascending: false);

      setState(() {
        _todos = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal memuat data: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _addTodo() async {
    if (_todoController.text.trim().isEmpty) return;

    try {
      await SupabaseConfig.client.from('todos').insert({
        'task': _todoController.text.trim(),
        'is_done': false,
      });
      _todoController.clear();
      await _fetchTodos();
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal menambah tugas: ${e.toString()}';
      });
    }
  }

  Future<void> _toggleDone(int index) async {
    try {
      await SupabaseConfig.client
          .from('todos')
          .update({'is_done': !_todos[index]['is_done']})
          .eq('id', _todos[index]['id']);
      await _fetchTodos();
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal mengupdate status: ${e.toString()}';
      });
    }
  }

  Future<void> _removeTodo(int index) async {
    try {
      await SupabaseConfig.client
          .from('todos')
          .delete()
          .eq('id', _todos[index]['id']);
      await _fetchTodos();
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal menghapus tugas: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _fetchTodos),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _todoController,
                    decoration: const InputDecoration(
                      hintText: 'Tambahkan tugas baru...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addTodo(),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton.small(
                  onPressed: _addTodo,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),

          // Error Message
          if (_errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                _errorMessage,
                style: TextStyle(color: Colors.red[700]),
              ),
            ),

          if (_isLoading)
            const LinearProgressIndicator()
          else if (_todos.isEmpty)
            const Expanded(child: Center(child: Text('Tidak ada tugas')))
          else
            Expanded(
              child: ListView.builder(
                itemCount: _todos.length,
                itemBuilder: (context, index) {
                  final todo = _todos[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 4.0,
                    ),
                    child: ListTile(
                      leading: Checkbox(
                        value: todo['is_done'],
                        onChanged: (_) => _toggleDone(index),
                      ),
                      title: Text(
                        todo['task'],
                        style: TextStyle(
                          decoration: todo['is_done']
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeTodo(index),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
