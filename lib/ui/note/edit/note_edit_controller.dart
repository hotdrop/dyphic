import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/model/note.dart';
import 'package:dyphic/repository/note_repository.dart';

part 'note_edit_controller.g.dart';

@riverpod
class NoteEditController extends _$NoteEditController {
  @override
  Future<void> build(int id) async {
    final target = await ref.read(noteRepositoryProvider).find(id);
    final uiState = (target == null) ? _UiState.createEmpty(id: id) : _UiState.create(target);
    ref.read(noteUiStateProvider.notifier).state = uiState;
  }
}

final noteEditMethodsProvider = Provider((ref) => _NoteEditMethods(ref));

class _NoteEditMethods {
  const _NoteEditMethods(this.ref);

  final Ref ref;

  void inputType(int newVal) {
    ref.read(noteUiStateProvider.notifier).update(
          (state) => state.copyWith(typeValue: newVal),
        );
  }

  void inputTitle(String newVal) {
    ref.read(noteUiStateProvider.notifier).update(
          (state) => state.copyWith(title: newVal),
        );
  }

  void inputDetail(String newVal) {
    ref.read(noteUiStateProvider.notifier).update(
          (state) => state.copyWith(detail: newVal),
        );
  }

  Future<void> save() async {
    try {
      final newNote = ref.read(noteUiStateProvider).toNote();
      await ref.read(noteRepositoryProvider).save(newNote);
    } catch (e, s) {
      await AppLogger.e('ノートの保存に失敗しました。', e, s);
      rethrow;
    }
  }
}

final noteUiStateProvider = StateProvider((_) => _UiState.createEmpty());

// ノート情報の登録可能条件。これがtrueになれば登録ボタンを押せる
final canSaveNoteEditStateProvider = Provider<bool>((ref) {
  final title = ref.watch(noteUiStateProvider).title;
  return title.isNotEmpty;
});

///
/// 入力保持用のクラス
///
class _UiState {
  const _UiState({
    required this.id,
    required this.title,
    required this.detail,
    required this.typeValue,
  });

  factory _UiState.create(Note n) {
    return _UiState(
      id: n.id,
      title: n.title,
      detail: n.detail,
      typeValue: n.typeValue,
    );
  }

  factory _UiState.createEmpty({int id = emptyId}) {
    return _UiState(
      id: id,
      title: '',
      detail: '',
      typeValue: NoteType.values.first.typeValue,
    );
  }

  final int id;
  final String title;
  final String detail;
  final int typeValue;

  static const emptyId = -1;

  Note toNote() {
    return Note(
      id: id,
      typeValue: typeValue,
      title: title,
      detail: detail,
    );
  }

  _UiState copyWith({
    String? title,
    String? detail,
    int? typeValue,
  }) {
    return _UiState(
      id: id,
      title: title ?? this.title,
      detail: detail ?? this.detail,
      typeValue: typeValue ?? this.typeValue,
    );
  }
}
