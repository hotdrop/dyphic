import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/common/app_strings.dart';
import 'package:dyphic/model/app_settings.dart';
import 'package:dyphic/model/note.dart';
import 'package:dyphic/model/page_state.dart';
import 'package:dyphic/ui/note/edit/note_edit_page.dart';
import 'package:dyphic/ui/note/notes_view_model.dart';
import 'package:dyphic/ui/note/widget_note_type_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NotesViewModel>(
      create: (_) => NotesViewModel.create(),
      builder: (context, _) {
        final pageState = context.select<NotesViewModel, PageLoadingState>((vm) => vm.pageState);
        if (pageState.isLoadSuccess) {
          return _loadSuccessView(context);
        } else {
          return _nowLoadingView();
        }
      },
      child: _nowLoadingView(),
    );
  }

  Widget _nowLoadingView() {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(AppStrings.notesPageTitle),
      ),
      body: Center(
        child: const CircularProgressIndicator(),
      ),
    );
  }

  Widget _loadSuccessView(BuildContext context) {
    final isLogin = Provider.of<AppSettings>(context).isLogin;
    final viewModel = Provider.of<NotesViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(AppStrings.notesPageTitle),
      ),
      body: _contentsView(context),
      floatingActionButton: isLogin
          ? FloatingActionButton(
              onPressed: () async {
                int newId = viewModel.createNewId();
                bool isUpdate = await Navigator.of(context).push<bool>(
                      MaterialPageRoute(builder: (_) => NoteEditPage(Note.createEmpty(newId))),
                    ) ??
                    false;
                AppLogger.d('戻り値: $isUpdate');
                if (isUpdate) {
                  await viewModel.reload();
                }
              },
              child: Icon(Icons.add),
            )
          : null,
    );
  }

  Widget _contentsView(BuildContext context) {
    final viewModel = Provider.of<NotesViewModel>(context);
    final notes = viewModel.notes;
    if (notes.isEmpty) {
      return Center(
        child: const Text(AppStrings.notesNotRegisterLabel),
      );
    } else {
      return ListView.builder(
        itemCount: notes.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            elevation: 1.0,
            child: ListTile(
              leading: NoteTypeIcon.createNote(notes[index]),
              title: Text(notes[index].title),
              onTap: () async {
                bool isUpdate = await Navigator.of(context).push<bool>(
                      MaterialPageRoute(builder: (_) => NoteEditPage(notes[index])),
                    ) ??
                    false;
                AppLogger.d('戻り値: $isUpdate');
                if (isUpdate) {
                  await viewModel.reload();
                }
              },
            ),
          );
        },
      );
    }
  }
}
