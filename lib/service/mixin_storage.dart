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

    final ref = FirebaseStorage().ref().child('images/$fileName');
    File localImageFile = File(localFilePath);
    final task = ref.putFile(localImageFile);
    final taskSnapshot = await task.onComplete;
    final url = await taskSnapshot.ref.getDownloadURL() as String;

    AppLogger.i('ファイルをStorageに保存しました。 path=$url');
    return url;
  }

  Future<String> readEventJson() async {
    return await _readJson(eventJsonFileName);
  }

  Future<bool> isUpdateEventJson(DateTime previousReadDate) async {
    if (previousReadDate == null) {
      return true;
    }

    final ref = FirebaseStorage().ref().child(eventJsonFileName);
    final metadata = await ref.getMetadata();
    final updateDateTime = DateTime.fromMillisecondsSinceEpoch(metadata.updatedTimeMillis);
    AppLogger.i('event.jsonの更新日時: $updateDateTime');
    final updateDate = DateTime(updateDateTime.year, updateDateTime.month, updateDateTime.day);

    return previousReadDate.isBefore(updateDate);
  }

  Future<String> _readJson(String fileName) async {
    final ref = FirebaseStorage().ref().child(fileName);
    final url = await ref.getDownloadURL() as String;
    final response = await http.get(url);
    return utf8.decode(response.bodyBytes);
  }
}
