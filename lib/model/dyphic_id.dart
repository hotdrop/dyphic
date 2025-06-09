import 'package:intl/intl.dart';

///
/// 記録情報のIDは全て日付をそのまま数値にした値にしている。
/// (20210210 のような値）
/// IDの生成や変換処理が点在しないよう全部このクラスで行う。
///
class DyphicID {
  const DyphicID._();

  static int createId(DateTime date) {
    final str = DateFormat('yyyyMMdd').format(date);
    return int.parse(str);
  }

  static int dateToId(DateTime date) {
    final dateStr = DateFormat('yyyyMMdd').format(date);
    return int.parse(dateStr);
  }

  static DateTime idToDate(int id) {
    return DateTime.parse(id.toString());
  }
}
