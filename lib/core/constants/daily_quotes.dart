import 'dart:math';

/// Quote motivasi harian (bahasa Indonesia).
class DailyQuotes {
  DailyQuotes._();

  static const List<Map<String, String>> quotes = [
    {'text': 'Kebiasaan kecil hari ini, adalah versi dirimu di masa depan.', 'author': 'James Clear'},
    {'text': 'Konsisten lebih berharga daripada sempurna.', 'author': 'Anonim'},
    {'text': 'Satu persen lebih baik setiap hari, cukup mengubah segalanya.', 'author': 'Atomic Habits'},
    {'text': 'Rutinitas adalah jalan pintas menuju kebebasan.', 'author': 'Mike Murdock'},
    {'text': 'Disiplin adalah jembatan antara tujuan dan pencapaian.', 'author': 'Jim Rohn'},
    {'text': 'Jangan hancurkan streak. Satu hari sekarang, masa depan nanti.', 'author': 'ROUTINE'},
    {'text': 'Yang kamu lakukan setiap hari lebih penting dari yang kamu lakukan sekali-sekali.', 'author': 'Gretchen Rubin'},
    {'text': 'Kamu tidak naik ke level tujuanmu, tapi jatuh ke level rutinitasmu.', 'author': 'James Clear'},
    {'text': 'Mulai dari kecil. Mulai sekarang. Mulai di sini.', 'author': 'Anonim'},
    {'text': 'Kemenangan kecil yang diulang, adalah kemenangan besar.', 'author': 'Anonim'},
    {'text': 'Motivasi membuatmu mulai. Kebiasaan membuatmu bertahan.', 'author': 'Jim Rohn'},
    {'text': 'Fokus pada proses, hasil akan mengikuti.', 'author': 'Anonim'},
    {'text': 'Hari yang baik dimulai dari keputusan kecil: bangun, bergerak, bersyukur.', 'author': 'ROUTINE'},
    {'text': 'Kebiasaan baik sulit dibangun, mudah dihidupi. Kebiasaan buruk kebalikannya.', 'author': 'Anonim'},
    {'text': 'Menang atau belajar. Tidak pernah kalah.', 'author': 'Nelson Mandela'},
  ];

  /// Quote konsisten untuk tanggal yang sama (hash berdasarkan tanggal).
  static Map<String, String> forDate(DateTime? date) {
    try {
      final d = date ?? DateTime.now();
      final key = d.year * 10000 + d.month * 100 + d.day;
      final index = key % quotes.length;
      return quotes[index];
    } catch (_) {
      return quotes[0];
    }
  }

  static Map<String, String> random() {
    return quotes[Random().nextInt(quotes.length)];
  }
}
