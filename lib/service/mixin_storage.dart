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

  Future<Map<String, dynamic>?> readEventJson() async {
    try {
      final url = await FirebaseStorage.instance.ref(_eventJsonFileName).getDownloadURL();
      final response = await http.get(Uri.parse(url));

      final bodyDecode = convert.utf8.decode(response.bodyBytes);
      return convert.jsonDecode(bodyDecode) as Map<String, dynamic>;
    } catch (e, s) {
      AppLogger.e('イベント情報が取得できませんでした。', e, s);
      return null;
    }
  }
}
