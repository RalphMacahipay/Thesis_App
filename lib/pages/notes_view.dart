// ignore_for_file: use_build_context_synchronously
import 'package:accounts/enum/enum.dart';
import 'package:accounts/pages/notes_list_view.dart';
import 'package:accounts/routes/route_pages.dart';
import 'package:accounts/services/auth/auth_service.dart';
import 'package:accounts/services/crud/note_service.dart';
import 'package:accounts/utility/logout_dialog.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtool show log;

class NotesListView extends StatefulWidget {
  const NotesListView({Key? key}) : super(key: key);

  @override
  State<NotesListView> createState() => _NotesListViewState();
}

class _NotesListViewState extends State<NotesListView> {
  late final NotesService _notesService;
  String get userEmail => AuthService.firebase().currentUser!.email!;

  // need naka open ang database pag na success sa pag login
  @override
  void initState() {
    _notesService = NotesService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //-----------------------------------Add new Button button-------------------
    final newButton = IconButton(
        onPressed: () {
          Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
        },
        icon: const Icon(Icons.add));
    //-----------------------------------logout button-------------------
    const logoutButton = PopupMenuItem<MenuAction>(
      value: MenuAction.logout,
      child: Text('Logout'),
    );
    //-----------------------------------PopUpbutton for logout (3 dots)--------
    final threeDOtsButton =
        PopupMenuButton<MenuAction>(onSelected: (value) async {
      switch (value) {
        case MenuAction.logout:
          final showLogout = await showLogoutDialog(context);
          if (showLogout) {
            await AuthService.firebase().logout();
            Navigator.of(context)
                .pushNamedAndRemoveUntil(loginPageRoute, (route) => false);
          }
          devtool.log(showLogout.toString());
      }
    }, itemBuilder: (context) {
      return [
        logoutButton,
      ];
    });
    //-----------------------------------Scaffold-------------------------------
    return Scaffold(
        appBar: AppBar(
          title: const Text("Home Page"),
          actions: [
            newButton,
            threeDOtsButton,
          ],
        ),
        body: FutureBuilder(
          // to expose user in UI
          future: _notesService.getOrcreateUser(email: userEmail),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return StreamBuilder(
                    stream: _notesService.allNotes,
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                        case ConnectionState.active:
                          if (snapshot.hasData) {
                            final allNotes =
                                snapshot.data as List<DatabaseNote>;
                            return NewListNote(
                              notes: allNotes,
                              onDeleteNote: (note) async {
                                await _notesService.deleteNote(id: note.id);
                              },
                              onTap: (note) {
                                Navigator.of(context).pushNamed(
                                    createOrUpdateNoteRoute,
                                    arguments: note);
                              },
                            );
                          } else {
                            return const CircularProgressIndicator();
                          }

                        default:
                          return const CircularProgressIndicator();
                      }
                    });
              default:
                return const CircularProgressIndicator();
            }
          },
        ));
  }
}
