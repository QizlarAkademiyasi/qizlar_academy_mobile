import 'dart:io';

import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/apis.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/model/profile_overview_model.dart';

/// Tahrirlash ekranidagi dumaloq avatar, pushti hoshiya va kamera tugmasi.
class EditInformationAvatar extends StatelessWidget {
  const EditInformationAvatar({super.key, required this.user, this.localFilePath, required this.isBusy, required this.onCameraTap});

  final ProfileUserModel user;
  final String? localFilePath;
  final bool isBusy;
  final VoidCallback onCameraTap;

  static const double _avatarSize = 120;
  static const double _fabSize = 36;

  @override
  Widget build(BuildContext context) {
    final remote = Apis.resolveUrl(user.avatarUrl.trim());
    final localPath = localFilePath?.trim() ?? '';
    final hasLocal = localPath.isNotEmpty && File(localPath).existsSync();

    return Center(
      child: SizedBox(
        width: _avatarSize + 8,
        height: _avatarSize + 8,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Container(
              width: _avatarSize,
              height: _avatarSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: context.appColors.primary, width: 4),
                boxShadow: [BoxShadow(color: context.appColors.shadow.withValues(alpha: 0.08), blurRadius: 24, offset: const Offset(0, 10))],
              ),
              child: AppTappableProfileAvatar(
                size: _avatarSize,
                borderWidth: 0,
                heroId: 'edit_profile_${user.userId}',
                resolvedNetworkUrl: hasLocal ? '' : remote,
                localFileAbsolutePath: hasLocal ? localPath : null,
                placeholder: _placeholder(context),
              ),
            ),
            Positioned(
              right: 8,
              bottom: 0,
              child: Material(
                color: Colors.transparent,
                type: MaterialType.transparency,
                shape: CircleBorder(),
                child: InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: isBusy ? null : onCameraTap,
                  customBorder: const CircleBorder(),
                  child: Ink(
                    width: _fabSize,
                    height: _fabSize,
                    decoration: BoxDecoration(
                      border: Border.all(color: context.appColors.background, width: 3),
                      color: context.appColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: isBusy
                        ? Padding(
                            padding: const EdgeInsets.all(8),
                            child: CircularProgressIndicator(strokeWidth: 2, color: context.theme.colorScheme.onPrimary),
                          )
                        : Icon(LucideIcons.camera, size: 18, color: AppColors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder(BuildContext context) {
    return ColoredBox(
      color: context.appColors.stroke,
      child: Icon(LucideIcons.user, color: context.appColors.grey, size: 48),
    );
  }
}
