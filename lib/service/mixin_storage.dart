import 'dart:convert' as convert;
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:dyphic/common/app_logger.dart';

mixin AppStorageMixin {
  static const String _eventJsonFileName = 'event.json';

  Future<String> saveImage(String localFilePath) async {
    String fileName = basename(localFilePath);
    File localFile = File(localFilePath);

    final task = await FirebaseStorage.instance.ref('images/$fileName').putFile(localFile);
    final url = await task.ref.getDownloadURL();
    AppLogger.d('ファイルをStorageに保存しました。 path=$url');
    return url;
  }

  Future<dynamic> readEventJson() async {
    final url = await FirebaseStorage.instance.ref(_eventJsonFileName).getDownloadURL();
    final response = await http.get(Uri.parse(url));

    final bodyDecode = convert.utf8.decode(response.bodyBytes);
    return convert.jsonDecode(bodyDecode);
  }

  Future<bool> isUpdateEventJson(DateTime? previousReadDate) async {
    if (previousReadDate == null) {
      return true;
    }

    final metadata = await FirebaseStorage.instance.ref(_eventJsonFileName).getMetadata();
    final updateAt = metadata.updated;
    AppLogger.d('event.jsonの更新日時: $updateAt');
    if (updateAt != null) {
      final updateDate = DateTime(updateAt.year, updateAt.month, updateAt.day);
      return previousReadDate.isBefore(updateDate);
    } else {
      // updateAtが取れない場合はファイルが存在しないので無条件でfalseにする
      return false;
    }
  }
}
