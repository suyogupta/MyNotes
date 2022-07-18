import 'dart:developer';

// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';
import 'package:mynotes/services/cloud/firebase_cloud.dart';
import 'package:mynotes/services/crud/notes_service.dart';
import 'package:mynotes/utilities/dialog/logout_dialog.dart';
import 'package:mynotes/view/notes_list_view.dart';

import '../constants/routes.dart';
import '../enums/menu_action.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  // late final NotesService _notesService;
  late final FirebaseCloudStorage _notesService;
  // String get userEmail => AuthService.firbase().currentUser!.email;
  String get userId => AuthService.firbase().currentUser!.id;
  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    // _notesService.oen();
    // TODO: implement initState
    super.initState();
  }

  // @override
  // void dispose() {
  //   _notesService.close();
  //   // TODO: implement dispose
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Notes'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(createOrUpdateNoteRoute,arguments: "Jai Shree Shyam");
                },
                icon: const Icon(Icons.add)),
            PopupMenuButton(
              onSelected: (value) async {
                log(value.toString());
                switch (value) {
                  case MenuAction.logout:
                    final shouldLogout = await showLogoutDialog(context);
                    if (shouldLogout) {
                      // FirebaseAuth.instance.signOut();
                      await AuthService.firbase().logOut();
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil(loginRoute, (_) => false);
                      // return LoginView();

                    }
                    break;

                  default:
                }
              },
              itemBuilder: (context) {
                return const [
                  PopupMenuItem<MenuAction>(
                      value: MenuAction.logout, child: Text('Logout')),
                ];
              },
            )
          ],
        ),
        // body: FutureBuilder(
        body: 
          // future: _notesService.getOrCreateUser(email: userEmail),
          // builder: (context, snapshot) {
            // switch (snapshot.connectionState) {
              // case ConnectionState.done:
                // TODO: Handle this case.
                // return
                 StreamBuilder(
                    // stream: _notesService.allNotes,
                    stream: _notesService.allNotes(ownerUserId: userId),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                        // return const Text("Waiting for all notes...");
                        case ConnectionState.active:
                          if (snapshot.hasData) {
                            final allNotes =
                                snapshot.data as Iterable<CloudNote>;
                            // print(allNotes);
                            // return const Text('Got all the notes');
                            return NotesListView(
                              notes: allNotes,
                              onDeleteNote: (note) async {
                                // await _notesService.deleteNote(id: note.id);
                                await _notesService.deleteNote(documentId: note.documentId);
                              },
                              onTap: (note) {
                                Navigator.of(context).pushNamed(createOrUpdateNoteRoute,arguments: note);
                              },
                            );
                          } else {
                            return const CircularProgressIndicator();
                          }

                        default:
                          return const CircularProgressIndicator();
                      }
                    }
                    ),
              // default:
                // return const CircularProgressIndicator();
            // }
          // },
        // )
        );
  }
}

// Future<bool> showLogoutDialog(BuildContext context) {
//   return showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Sign Out'),
//           content: const Text('Are you sure you want to sign out?'),
//           actions: [
//             TextButton(
//                 onPressed: () {
//                   Navigator.pop(context, false);
//                 },
//                 child: const Text('Cancel')),
//             TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop(true);
//                 },
//                 child: const Text('Logout')),
//           ],
//         );
//       }).then((value) => value ?? false);
// }