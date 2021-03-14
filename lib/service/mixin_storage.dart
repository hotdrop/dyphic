import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

import 'package:dyphic/common/app_logger.dart';

mixin AppStorageMixin {
  final eventJsonFileName = 'event.json';

  Future<String> saveImage(String localFilePath) async {
    String fileName = basename(localFilePath);
    File localFile = File(localFilePath);

    try {
      final task = await FirebaseStorage.instance.ref('images/$fileName').putFile(localFile);
      final url = await task.ref.getDownloadURL();
      AppLogger.d('ファイルをStorageに保存しました。 path=$url');
      return url;
    } on FirebaseException catch (e, s) {
      await AppLogger.e('FirebaseStorage: 保存処理に失敗', e, s);
      rethrow;
    }
  }

  Future<String> readEventJson() async {
    try {
      final url = await FirebaseStorage.instance.ref(eventJsonFileName).getDownloadURL();
      final uri = Uri.parse(url);
      final response = await http.get(uri);
      return utf8.decode(response.bodyBytes);
    } on FirebaseException catch (e, s) {
      await AppLogger.e('FirebaseStorage: $eventJsonFileNameの読み込みに失敗', e, s);
      rethrow;
    }
  }

  Future<bool> isUpdateEventJson(DateTime? previousReadDate) async {
    if (previousReadDate == null) {
      return true;
    }

    try {
      final metadata = await FirebaseStorage.instance.ref(eventJsonFileName).getMetadata();
      final updateAt = metadata.updated;
      AppLogger.d('event.jsonの更新日時: $updateAt');
      if (updateAt != null) {
        final updateDate = DateTime(updateAt.year, updateAt.month, updateAt.day);
        return previousReadDate.isBefore(updateDate);
      } else {
        // updateAtが取れない場合はファイルが存在しないので無条件でfalseにする
        return false;
      }
    } on FirebaseException catch (e, s) {
      await AppLogger.e('FirebaseStorage: $eventJsonFileNameの更新日時取得に失敗', e, s);
      rethrow;
    }
  }
}
