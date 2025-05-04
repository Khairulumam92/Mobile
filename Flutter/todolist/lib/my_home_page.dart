import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'todo_list_page.dart';
import 'notes_page.dart';
import 'pomodoro_page.dart';
import 'settings_page.dart';

class NotesSearchDelegate extends SearchDelegate {
  final List<Map<String, String>> notes;
  final Function(String) onSearch;

  NotesSearchDelegate({required this.notes, required this.onSearch});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          onSearch(query);
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final filteredNotes = notes
        .where((note) =>
            (note['title']?.toLowerCase().contains(query.toLowerCase()) ??
                false) ||
            (note['content']?.toLowerCase().contains(query.toLowerCase()) ??
                false))
        .toList();

    return ListView.builder(
      itemCount: filteredNotes.length,
      itemBuilder: (context, index) {
        final note = filteredNotes[index];
        return ListTile(
          title: Text(note['title'] ?? ''),
          subtitle: Text(note['content'] ?? ''),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _searchQuery = '';

  final List<Map<String, String>> notes = [
    {'title': 'Note 1', 'content': 'Content of note 1'},
    {'title': 'Note 2', 'content': 'Content of note 2'},
    {'title': 'Note 3', 'content': 'Content of note 3'},
  ];

  List<Map<String, String>> get _filteredNotes {
    if (_searchQuery.isEmpty) {
      return notes;
    }
    return notes
        .where((note) =>
            (note['title']
                    ?.toLowerCase()
                    .contains(_searchQuery.toLowerCase()) ??
                false) ||
            (note['content']
                    ?.toLowerCase()
                    .contains(_searchQuery.toLowerCase()) ??
                false))
        .toList();
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return DateFormat('HH:mm').format(now);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: NotesSearchDelegate(
                  notes: notes,
                  onSearch: (query) {
                    setState(() {
                      _searchQuery = query;
                    });
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Clock at the top
          Center(
            child: Column(
              children: [
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
