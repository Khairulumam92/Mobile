import 'package:flutter/material.dart';

class AddNotePage extends StatelessWidget {
  final Function(Map<String, String>) onNoteAdded;
  final String? initialTitle;
  final String? initialContent;

  AddNotePage({
    required this.onNoteAdded,
    this.initialTitle,
    this.initialContent,
  });

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    titleController.text = initialTitle ?? '';
    contentController.text = initialContent ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Catatan Baru'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Judul Catatan',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: contentController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Isi Catatan',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty ||
                    contentController.text.isNotEmpty) {
                  onNoteAdded({
                    'title': titleController.text,
                    'content': contentController.text,
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text('Simpan Catatan'),
            ),
          ],
        ),
      ),
    );
  }
}
