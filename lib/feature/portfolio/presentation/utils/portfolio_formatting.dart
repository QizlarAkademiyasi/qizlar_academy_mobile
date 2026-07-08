import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';

abstract final class PortfolioFormatting {
  static String compactCount(int value) {
    if (value < 1000) {
      return value.toString();
    }
    if (value < 1000000) {
      return '${(value / 1000).toStringAsFixed(value >= 10000 ? 0 : 1)}K';
    }
    return '${(value / 1000000).toStringAsFixed(value >= 10000000 ? 0 : 1)}M';
  }

  static String relativeTime(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'hozir';
    if (diff.inMinutes < 60) return '${diff.inMinutes} daqiqa oldin';
    if (diff.inHours < 24) return '${diff.inHours} soat oldin';
    if (diff.inDays < 7) return '${diff.inDays} kun oldin';
    return DateFormat('dd MMM. yy', 'uz').format(date);
  }

  static String detailDate(DateTime date) =>
      DateFormat('dd MMM. yy', 'uz').format(date);

  static String detailTime(DateTime date) =>
      DateFormat('HH:mm', 'uz').format(date);

  static String duration(int? seconds) {
    if (seconds == null || seconds <= 0) return '';
    final minutes = seconds ~/ 60;
    final rest = seconds % 60;
    return '$minutes:${rest.toString().padLeft(2, '0')}';
  }
}
