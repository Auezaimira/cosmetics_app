import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../network/api_service.dart';
import '../providers/user_provider.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage({Key? key}) : super(key: key);

  @override
  _AddNotePageState createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();

  Future<void> saveNote() async {
    String? userId = Provider.of<UserProvider>(context, listen: false).user?.id;

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not found, please log in again')),
      );
      return;
    }

    final notePayload = {
      "title": _title.text,
      "description": _description.text,
      "userId": userId
    };

    try {
      await ApiService.addNote(notePayload);
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      final snackBar = SnackBar(content: Text('Error adding note: $e'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Note'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _title,
              decoration: const InputDecoration(hintText: 'Enter note text'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _description,
              decoration:
                  const InputDecoration(hintText: 'Enter note description'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveNote,
              child: const Text('Save Note'),
            ),
          ],
        ),
      ),
    );
  }
}
