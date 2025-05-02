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
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(notes[index]['title'] ?? 'Tanpa Judul'),
                      subtitle: Text(
                        notes[index]['content'] ?? '',
                        maxLines: 5, // Display up to 5 lines of content
                        overflow:
                            TextOverflow.ellipsis, // Add ellipsis for overflow
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
