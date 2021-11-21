import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dyphic/model/app_settings.dart';
import 'package:dyphic/res/app_strings.dart';
import 'package:dyphic/model/note.dart';
import 'package:dyphic/ui/note/edit/note_edit_page.dart';
import 'package:dyphic/ui/note/notes_view_model.dart';
import 'package:dyphic/ui/note/widget_note_type_icon.dart';
import 'package:dyphic/ui/widget/app_dialog.dart';

class NotesPage extends ConsumerWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(notesViewModelProvider).uiState;
    return uiState.when(
      loading: (String? errorMsg) => _onLoading(context, errorMsg),
      success: () => _onSuccess(context, ref),
    );
  }

  Widget _onLoading(BuildContext context, String? errorMsg) {
    Future.delayed(Duration.zero).then((_) async {
      if (errorMsg != null) {
        await AppDialog.onlyOk(message: errorMsg).show(context);
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.notesPageTitle),
      ),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _onSuccess(BuildContext context, WidgetRef ref) {
    final isSignIn = ref.watch(appSettingsProvider).isSignIn;
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.notesPageTitle),
      ),
      body: _viewBody(context, ref),
      floatingActionButton: isSignIn
          ? FloatingActionButton(
              onPressed: () async => await _onTapFab(context, ref),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Widget _viewBody(BuildContext context, WidgetRef ref) {
    final notes = ref.watch(notesProvider);
    if (notes.isEmpty) {
      return const Center(
        child: Text(AppStrings.notesNotRegisterLabel),
      );
    }

    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (ctx, index) => _RowNote(
        notes[index],
        onTap: () async {
          // await ref.read(notesViewModelProvider).reload();
        },
      ),
    );
  }

  Future<void> _onTapFab(BuildContext context, WidgetRef ref) async {
    final emptyNote = ref.read(notesProvider.notifier).newNote();
    final isUpdate = await NoteEditPage.start(context, emptyNote);
    // AppLogger.d('戻り値: $isUpdate');
    // if (isUpdate) {
    //   await ref.read(notesViewModelProvider).reload();
    // }
  }
}

class _RowNote extends StatelessWidget {
  const _RowNote(
    this._note, {
    Key? key,
    required this.onTap,
  }) : super(key: key);

  final Note _note;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.0,
      child: ListTile(
        leading: NoteTypeIcon.createNote(_note),
        title: Text(_note.title),
        onTap: () async {
          final isUpdate = await NoteEditPage.start(context, _note);
          // AppLogger.d('戻り値: $isUpdate');
          // if (isUpdate) {
          //   onTap();
          // }
        },
      ),
    );
  }
}
