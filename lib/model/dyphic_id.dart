import 'package:intl/intl.dart';

///
/// イベント情報と記録情報のIDは全て日付をそのまま数値にした値にしている。
/// (20210210 のような値）
/// IDの生成や変換処理が点在しないよう全部このクラスで行う。
///
class DyphicID {
  const DyphicID._();

  static int makeEventId(DateTime date) {
    final s = '${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}';
    return int.parse(s);
  }

  static int makeRecordId(DateTime date) {
    final str = DateFormat('yyyyMMdd').format(date);
    return int.parse(str);
  }

  static String dateToIdString(DateTime date) {
    return DateFormat('yyyyMMdd').format(date);
  }

  static DateTime idToDate(int id) {
    return DateTime.parse(id.toString());
  }
}
