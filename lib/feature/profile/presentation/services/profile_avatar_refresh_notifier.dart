import 'package:flutter/foundation.dart';

/// Profil rasmi o‘zgarganda (tahrirdan keyin) ostki bar va header yangi rasmni ko‘rsatishi uchun.
/// [generation] [AppCachedNetworkImage.cacheKey] ga qo‘shiladi — bir xil URL bo‘lsa ham kesh yangilanadi.
class ProfileAvatarRefreshNotifier extends ChangeNotifier {
  int _generation = 0;

  int get generation => _generation;

  void bumpAvatarCache() {
    _generation++;
    notifyListeners();
  }
}
