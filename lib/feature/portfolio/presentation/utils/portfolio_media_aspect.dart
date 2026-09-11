abstract final class PortfolioMediaAspect {
  static const double minRatio = 4 / 5;
  static const double maxRatio = 16 / 9;
  static const double imageFallbackRatio = 1;
  static const double videoFallbackRatio = 16 / 9;

  static double clampRatio(double width, double height) {
    if (width <= 0 || height <= 0) {
      return imageFallbackRatio;
    }
    return (width / height).clamp(minRatio, maxRatio);
  }

  static double fallbackRatio({required bool isVideo}) {
    return isVideo ? videoFallbackRatio : imageFallbackRatio;
  }
}

abstract final class PortfolioMediaAspectCache {
  static final Map<String, double> _ratios = <String, double>{};

  static double? get(String url) {
    final key = url.trim();
    if (key.isEmpty) {
      return null;
    }
    return _ratios[key];
  }

  static void set(String url, double ratio) {
    final key = url.trim();
    if (key.isEmpty) {
      return;
    }
    _ratios[key] = ratio;
  }

  static void clear() => _ratios.clear();
}
