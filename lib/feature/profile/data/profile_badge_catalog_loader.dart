import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/model/profile_badge_definition.dart';

/// `assets/profile/profile_badges.json` ni bir marta o‘qiydi (kesh).
class ProfileBadgeCatalogLoader {
  ProfileBadgeCatalogLoader._();

  static List<ProfileBadgeDefinition>? _cache;

  static Future<List<ProfileBadgeDefinition>> load() async {
    if (_cache != null) return _cache!;
    final raw = await rootBundle.loadString('assets/profile/profile_badges.json');
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final list = decoded['badges'] as List<dynamic>;
    _cache = list.map((dynamic e) {
      final m = e as Map<String, dynamic>;
      return ProfileBadgeDefinition(
        id: (m['id'] as num).toInt(),
        file: m['file'] as String,
        key: m['key'] as String?,
      );
    }).toList()
      ..sort((a, b) => a.id.compareTo(b.id));
    return _cache!;
  }

  /// Server `badge` katalogda bo‘lmasa, birinchi badge tanlanadi.
  static int coerceSelection(int serverBadgeId, List<ProfileBadgeDefinition> catalog) {
    if (catalog.isEmpty) return 0;
    for (final b in catalog) {
      if (b.id == serverBadgeId) return serverBadgeId;
    }
    return catalog.first.id;
  }
}
