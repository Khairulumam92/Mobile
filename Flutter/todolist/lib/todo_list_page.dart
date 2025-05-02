import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  List<Map<String, dynamic>> _tasks = [];
  final TextEditingController _taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTasks = prefs.getStringList('tasks') ?? [];
    print('Loaded tasks from SharedPreferences: $savedTasks'); // Debug log
    setState(() {
      _tasks = savedTasks.map((task) {
        final parts = task.split('|');
        return {'title': parts[0], 'completed': parts[1] == 'true'};
      }).toList();
      print('Parsed tasks into list: $_tasks'); // Debug log
    });
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTasks =
        _tasks.map((task) => '${task['title']}|${task['completed']}').toList();
    print('Saving tasks to SharedPreferences: $savedTasks'); // Debug log
    await prefs.setStringList('tasks', savedTasks);
  }

  void _addTask() {
    if (_taskController.text.isNotEmpty) {
      setState(() {
        final newTask = {'title': _taskController.text, 'completed': false};
        _tasks.add(newTask);
        print('Added new task: $newTask'); // Debug log
        _taskController.clear();
      });
      _saveTasks();
    } else {
      print('Task input is empty, not adding task.'); // Debug log
    }
  }

  void _removeTaskAt(int index) {
    setState(() {
      _tasks.removeAt(index);
      _saveTasks();
    });
  }

  void _toggleTaskCompletion(int index) {
    setState(() {
      _tasks[index]['completed'] = !_tasks[index]['completed'];
      _saveTasks();
    });
  }

  void _editTask(int index) {
    _taskController.text = _tasks[index]['title'];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Tugas'),
          content: TextField(
            controller: _taskController,
            decoration: InputDecoration(
              labelText: 'Judul Tugas',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (_taskController.text.isNotEmpty) {
                    _tasks[index]['title'] = _taskController.text;
                    _saveTasks();
                  }
                });
                _taskController.clear();
                Navigator.of(context).pop();
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _taskController,
              decoration: InputDecoration(
                labelText: 'Tambah Tugas',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addTask,
              child: Text('Tambah'),
            ),
            Expanded(
              child: _tasks.isEmpty
                  ? Center(
                      child: Text('Tidak ada tugas. Tambahkan tugas baru!'),
                    )
                  : ListView.builder(
                      itemCount: _tasks.length,
                      itemBuilder: (context, index) {
                        print(
                            'Displaying task at index $index: ${_tasks[index]}'); // Debug log
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            leading: Checkbox(
                              value: _tasks[index]['completed'],
                              onChanged: (value) {
                                _toggleTaskCompletion(index);
                              },
                            ),
                            title: Text(
                              _tasks[index]['title'],
                              style: TextStyle(
                                decoration: _tasks[index]['completed']
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () => _editTask(index),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () => _removeTaskAt(index),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
