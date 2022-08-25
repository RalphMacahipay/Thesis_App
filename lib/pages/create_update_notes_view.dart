import 'package:accounts/services/auth/auth_service.dart';
import 'package:accounts/services/crud/note_service.dart';
import 'package:accounts/utility/get_arguments.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtool show log;
import 'package:path/path.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({Key? key}) : super(key: key);

  @override
  State<CreateUpdateNoteView> createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  DatabaseNote? _note;
  late final NotesService _notesService;
  late final TextEditingController _textController;

  // to use the fucntions of notesService properly
  @override
  void initState() {
    _notesService = NotesService();
    _textController = TextEditingController();
    super.initState();
  }

  void _textControllerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textController.text;
    await _notesService.updateNote(note: note, text: text);
  }

  void _setuptextControllerListener() async {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  // checking if yung note na gagawin ay nag e exist sa database or hindi
  // if hindi mag create if oo pwede i edit
  Future<DatabaseNote> createOrGetExistingNOte(BuildContext context) async {
    final widgetNote = context.getArgument<DatabaseNote>();
    if (widgetNote != null) {
      _note = widgetNote;
      _textController.text = widgetNote.text;
      return widgetNote;
    }
    final exisitingNote = _note;
    if (exisitingNote != null) {
      return exisitingNote;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final email = currentUser.email!;
    final owner = await _notesService.getUser(email: email); //test

    final newNote = await _notesService.createNote(owner: owner);
    _note = newNote;
    return newNote;
  }

  // pag na back button ni user after i click yung + button to avoid empty note
  void _deleteNoteIfTextIsEmpty() {
    final note = _note;
    if (_textController.text.isEmpty && note != null) {
      _notesService.deleteNote(id: note.id);
    }
  }

  Future<void> _saveNoteIfTextIsNotEmpty() async {
    final note = _note;
    final text = _textController.text;
    if (text.isNotEmpty && note != null) {
      await _notesService.updateNote(note: note, text: text);
    }
  }

  // to dispose the functions for creating the note
  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextIsNotEmpty();
    _textController.dispose();
    super.dispose();
  }

  //---------------Scaffold --------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('New'),
        ),
        body: FutureBuilder(
          future: createOrGetExistingNOte(context),
          builder: ((context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                _setuptextControllerListener();
                return TextField(
                  controller: _textController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  // decoration: const InputDecoration(hintText: "Enter Notes"),
                );
              default:
                return const CircularProgressIndicator();
            }
          }),
        ));
  }
}
