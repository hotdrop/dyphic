import 'dart:math';
import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/model/note.dart';
import 'package:dyphic/repository/account_repository.dart';
import 'package:dyphic/repository/note_repository.dart';
import 'package:dyphic/ui/base_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notesViewModelProvider = ChangeNotifierProvider.autoDispose((ref) => _NotesViewModel(ref.read));

class _NotesViewModel extends BaseViewModel {
  _NotesViewModel(this._read) {
    _init();
  }

  final Reader _read;
  bool get isSignIn => _read(accountRepositoryProvider).isSignIn;

  late List<Note> _notes;
  List<Note> get notes => _notes;

  Future<void> _init() async {
    try {
      _notes = await _read(noteRepositoryProvider).findAll();
      onSuccess();
    } catch (e, s) {
      await AppLogger.e('ノート一覧の取得に失敗しました。', e, s);
      onError('$e');
    }
  }

  Future<void> reload() async {
    try {
      _notes = await _read(noteRepositoryProvider).findAll();
      notifyListeners();
    } catch (e, s) {
      await AppLogger.e('ノート一覧の取得に失敗しました。', e, s);
      onError('$e');
    }
  }

  int createNewId() {
    return (_notes.isNotEmpty) ? _notes.map((e) => e.id).reduce(max) + 1 : 1;
  }
}
