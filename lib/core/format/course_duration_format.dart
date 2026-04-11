/// Backend `totalDuration` maydonlari **daqiqa** (minutes) sifatida keladi (sekund yoki soat emas).
abstract final class CourseDurationFormat {
  CourseDurationFormat._();

  /// Ro‘yxat / kartalar: musbat daqiqani soatga yaxlitlash (ceil), 0 → 0.
  static int displayHoursFromApiMinutes(int totalMinutes) {
    if (totalMinutes <= 0) return 0;
    return (totalMinutes + 59) ~/ 60;
  }

  /// Kurs/modul umumiy vaqti uchun kompakt matn (ichki hisob — sekund).
  static String compactFromApiMinutes(int totalMinutes) => compactFromTotalSeconds(totalMinutes * 60);

  static String compactFromTotalSeconds(int totalSeconds) {
    if (totalSeconds <= 0) return '0m';
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    if (hours <= 0) return '${minutes}m';
    if (minutes == 0) return '${hours}h';
    return '${hours}h ${minutes}m';
  }
}
