import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'add_note_page.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  List<Map<String, String>> notes = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  String _searchQuery = '';

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

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      final savedNotes = prefs.getStringList('notes') ?? [];
      notes = savedNotes.map((note) {
        final parts = note.split('|');
        return {'title': parts[0], 'content': parts[1]};
      }).toList();
    });
  }

  Future<void> _saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final savedNotes =
        notes.map((note) => '${note['title']}|${note['content']}').toList();
    prefs.setStringList('notes', savedNotes);
  }

  void _removeNoteAt(int index) {
    setState(() {
      notes.removeAt(index);
      _saveNotes();
    });
  }

  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Hapus'),
          content: Text('Apakah Anda yakin ingin menghapus catatan ini?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                _removeNoteAt(index);
                Navigator.of(context).pop();
              },
              child: Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  void _editNoteAt(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddNotePage(
          onNoteAdded: (updatedNote) {
            setState(() {
              notes[index] = updatedNote;
              _saveNotes();
            });
          },
          initialTitle: notes[index]['title'],
          initialContent: notes[index]['content'],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddNotePage(onNoteAdded: (newNote) {
                            setState(() {
                              notes.add(newNote);
                              _saveNotes();
                            });
                          })),
                );
              },
              child: Text('Tambah Catatan Baru'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredNotes.length,
                itemBuilder: (context, index) {
                  final note = _filteredNotes[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(note['title'] ?? 'Tanpa Judul'),
                      subtitle: Text(
                        note['content'] ?? '',
                        maxLines: null,
                        overflow: TextOverflow.visible,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => _editNoteAt(index),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _confirmDelete(index),
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
    onSearch(query);
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
          title: Text(note['title'] ?? 'Tanpa Judul'),
          subtitle: Text(note['content'] ?? ''),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
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
          title: Text(note['title'] ?? 'Tanpa Judul'),
          subtitle: Text(note['content'] ?? ''),
          onTap: () {
            query = note['title'] ?? '';
            showResults(context);
          },
        );
      },
    );
  }
}
