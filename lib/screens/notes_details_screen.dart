import 'package:flutter/material.dart';

import '../models/notes.model.dart';

class NoteDetailPage extends StatelessWidget {
  final Note note;

  const NoteDetailPage({Key? key, required this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(note.title),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('Sample', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
