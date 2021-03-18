import 'package:dyphic/model/note.dart';

class NoteRepository {
  const NoteRepository._();

  factory NoteRepository.create() {
    return NoteRepository._();
  }

  Future<List<Note>> findAll() async {
    // TODO Firestoreに保存する
    return [
      Note(id: 1, typeValue: 1, title: 'アイウエについて', detail: 'ECはうんぬんかんぬん'),
      Note(id: 2, typeValue: 1, title: 'あいうえについて', detail: 'アイウエオはあいうけお'),
      Note(id: 3, typeValue: 2, title: 'テスト', detail: 'アイウエオはあいうけお'),
      Note(id: 4, typeValue: 1, title: '光栄', detail: 'アイウエオはあいうけお'),
      Note(id: 5, typeValue: 3, title: 'テクモ', detail: 'アイウエオはあいうけお'),
      Note(id: 6, typeValue: 3, title: 'モンスター', detail: 'アイウエオはあいうけお'),
      Note(id: 7, typeValue: 3, title: 'ファーム', detail: 'アイウエオはあいうけお'),
      Note(id: 8, typeValue: 1, title: 'ベロリング', detail: 'アイウエオはあいうけお'),
      Note(id: 9, typeValue: 1, title: 'ユーチューバ', detail: 'アイウエオはあいうけお'),
    ];
  }

  Future<void> save(Note note) async {}
}
