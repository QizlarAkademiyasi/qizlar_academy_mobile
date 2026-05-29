/// Kunlik streak / sheet uchun kalend kun kaliti (`yyyy-MM-dd`, mahalliy vaqt).
final class DailyCoinCalendarDay {
  DailyCoinCalendarDay._();

  static String todayLocal([DateTime? now]) {
    final n = now ?? DateTime.now();
    final y = n.year.toString().padLeft(4, '0');
    final m = n.month.toString().padLeft(2, '0');
    final d = n.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }
}
