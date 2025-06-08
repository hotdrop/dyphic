import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dyphic/service/firebase_auth.dart';
import 'package:dyphic/model/note.dart';
import 'package:dyphic/ui/note/edit/note_edit_page.dart';
import 'package:dyphic/ui/note/notes_controller.dart';
import 'package:dyphic/ui/note/widget_note_type_icon.dart';

class NotesPage extends ConsumerWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(notesControllerProvider).when(
          data: (_) => const _ViewBody(),
          error: (err, stackTrace) {
            return Center(
              child: Text('$err', style: const TextStyle(color: Colors.red)),
            );
          },
          loading: () {
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        );
  }
}

class _ViewBody extends ConsumerWidget {
  const _ViewBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSignIn = ref.watch(firebaseAuthProvider).isSignIn;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ノート'),
      ),
      body: const _ViewNoteListView(),
      floatingActionButton: isSignIn
          ? FloatingActionButton(
              onPressed: () async => await _onTapFab(context, ref),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Future<void> _onTapFab(BuildContext context, WidgetRef ref) async {
    final newId = ref.read(notesControllerProvider.notifier).createNewId();
    await NoteEditPage.start(context, newId);
  }
}

class _ViewNoteListView extends ConsumerWidget {
  const _ViewNoteListView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notes = ref.watch(notesUiStateProvider);
    if (notes.isEmpty) {
      return const Center(
        child: Text('ノートが1つも登録されていません。'),
      );
    }

    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (ctx, index) => _RowNote(notes[index]),
    );
  }
}

class _RowNote extends StatelessWidget {
  const _RowNote(this.note);

  final Note note;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.0,
      child: ListTile(
        leading: NoteTypeIcon.createNote(note),
        title: Text(note.title),
        onTap: () async {
          await NoteEditPage.start(context, note.id);
        },
      ),
    );
  }
}
