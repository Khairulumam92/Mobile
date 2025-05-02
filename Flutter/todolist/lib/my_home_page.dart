import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'todo_list_page.dart';
import 'notes_page.dart';
import 'pomodoro_page.dart';
import 'settings_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _getCurrentTime() {
    final now = DateTime.now();
    return DateFormat('HH:mm').format(now);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Clock at the top
          Center(
            child: Column(
              children: [
                Text('Jam Digital',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                Text(_getCurrentTime(),
                    style:
                        TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          SizedBox(height: 20),
          // Menu buttons
          Expanded(
            child: ListView(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TodoListPage()),
                    );
                  },
                  icon: Icon(Icons.checklist),
                  label: Text('To-Do List'),
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NotesPage()),
                    );
                  },
                  icon: Icon(Icons.note),
                  label: Text('Notes'),
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PomodoroPage()),
                    );
                  },
                  icon: Icon(Icons.timer),
                  label: Text('Pomodoro'),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: 0, // Set the current index dynamically if needed
        onTap: (index) {
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsPage()),
            );
          }
        },
      ),
    );
  }
}
