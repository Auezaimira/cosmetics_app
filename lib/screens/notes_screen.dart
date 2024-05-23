import 'package:cosmetics_app/network/api_service.dart';
import 'package:cosmetics_app/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/notes.model.dart';
import 'add_note_screen.dart';
import 'notes_details_screen.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  static const mainColor = Color(0xFFF48FB1);
  late List<Note> _notes = [];

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  void fetchNotes() async {
    try {
      String? userId =
          Provider.of<UserProvider>(context, listen: false).user?.id;

      List<Note> notes = await ApiService.getNotes(userId!);
      setState(() {
        _notes = notes;
      });
    } catch (err) {
      print("Error fetching notes: $err");
      throw Exception(err);
    }
  }

  void _navigateAndDisplayNoteDetail(BuildContext context, Note note) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => NoteDetailPage(
                note: note,
              )),
    );
  }

  void _navigateAndAddNewNote(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddNotePage()),
    );
    fetchNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes', style: TextStyle(color: Colors.white)),
        backgroundColor: mainColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _notes.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: ListTile(
              title: Text(_notes[index].title),
              subtitle: Text(_notes[index].description),
              // onTap: () => _navigateAndDisplayNoteDetail(
              //     context, _notes[index].id as Note),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  setState(() {
                    _notes.removeAt(index);
                  });
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateAndAddNewNote(context),
        backgroundColor: mainColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
