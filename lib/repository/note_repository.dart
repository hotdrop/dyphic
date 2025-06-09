import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dyphic/model/note.dart';
import 'package:dyphic/repository/local/dao/note_dao.dart';
import 'package:dyphic/repository/remote/note_api.dart';

final noteRepositoryProvider = Provider((ref) => _NoteRepository(ref));

class _NoteRepository {
  const _NoteRepository(this._ref);

  final Ref _ref;

  ///
  /// 指定したIDのノート情報を取得する
  /// 取得先: ローカルストレージ
  ///
  Future<Note?> find(int id) async {
    return await _ref.read(noteDaoProvider).find(id);
  }

  ///
  /// 保持している全てのノート情報を取得する
  /// 取得先: ローカルストレージ
  ///
  Future<List<Note>> findAll() async {
    final notes = await _ref.read(noteDaoProvider).findAll();
    if (notes.isEmpty) {
      return [];
    }
    return notes;
  }

  ///
  /// ノート情報をサーバーから取得してローカルストレージのデータを最新化する
  /// 取得先: サーバー
  ///
  Future<void> onLoadLatest() async {
    final newNotes = await _ref.read(noteApiProvider).findAll();
    await _ref.read(noteDaoProvider).saveAll(newNotes);
  }

  ///
  /// ノート情報を保存する
  /// 保存先: ローカルストレージ, サーバー
  ///
  Future<void> save(Note newNote) async {
    await _ref.read(noteApiProvider).save(newNote);
    await _ref.read(noteDaoProvider).save(newNote);
  }
}
