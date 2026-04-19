import 'package:intl/intl.dart';

class AppDateUtils {
  AppDateUtils._();

  /// Normalisasi ke tanggal saja (jam 00:00).
  static DateTime dateOnly(DateTime? dt) {
    if (dt == null) {
      final now = DateTime.now();
      return DateTime(now.year, now.month, now.day);
    }
    return DateTime(dt.year, dt.month, dt.day);
  }

  /// Key stabil untuk membandingkan tanggal (yyyy-MM-dd).
  static String dateKey(DateTime? dt) {
    final d = dt ?? DateTime.now();
    return '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  static bool isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static String formatFullID(DateTime? dt) {
    if (dt == null) return '';
    return DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(dt);
  }

  static String formatShortID(DateTime? dt) {
    if (dt == null) return '';
    return DateFormat('d MMM yyyy', 'id_ID').format(dt);
  }

  static String formatMonthYear(DateTime? dt) {
    if (dt == null) return '';
    return DateFormat('MMMM yyyy', 'id_ID').format(dt);
  }

  static String formatDayMonth(DateTime? dt) {
    if (dt == null) return '';
    return DateFormat('d MMMM', 'id_ID').format(dt);
  }

  static int daysBetween(DateTime? from, DateTime? to) {
    if (from == null || to == null) return 0;
    final f = DateTime(from.year, from.month, from.day);
    final t = DateTime(to.year, to.month, to.day);
    return t.difference(f).inDays;
  }

  static String greetingByHour() {
    final h = DateTime.now().hour;
    if (h < 11) return 'Selamat Pagi';
    if (h < 15) return 'Selamat Siang';
    if (h < 18) return 'Selamat Sore';
    return 'Selamat Malam';
  }
}
