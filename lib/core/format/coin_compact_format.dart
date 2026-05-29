sealed class CoinCompactFormat {
  static String short(int value) {
    final absValue = value.abs();
    if (absValue < 1000) return value.toString();

    if (absValue < 1000000) {
      return _withSuffix(value / 1000, 'K');
    }

    if (absValue < 1000000000) {
      return _withSuffix(value / 1000000, 'M');
    }

    return _withSuffix(value / 1000000000, 'B');
  }

  static String _withSuffix(double normalized, String suffix) {
    final rounded = normalized >= 100 ? normalized.toStringAsFixed(0) : normalized.toStringAsFixed(1);
    final cleaned = rounded.endsWith('.0') ? rounded.substring(0, rounded.length - 2) : rounded;
    return '$cleaned$suffix';
  }
}
