import 'dart:io';

import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/apis.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/model/profile_overview_model.dart';

/// Tahrirlash ekranidagi dumaloq avatar, pushti hoshiya va kamera tugmasi.
class EditInformationAvatar extends StatelessWidget {
  const EditInformationAvatar({
    super.key,
    required this.user,
    this.localFilePath,
    required this.isBusy,
    required this.onCameraTap,
  });

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
                border: Border.all(
                  color: context.appColors.primary,
                  width: 4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: context.appColors.shadow.withValues(alpha: 0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipOval(
                child: hasLocal
                    ? Image.file(
                        File(localPath),
                        fit: BoxFit.cover,
                        width: _avatarSize,
                        height: _avatarSize,
                        errorBuilder: (_, _, _) => _placeholder(context),
                      )
                    : remote.isEmpty
                    ? _placeholder(context)
                    : AppCachedNetworkImage(
                        imageUrl: remote,
                        fit: BoxFit.cover,
                        width: _avatarSize,
                        height: _avatarSize,
                        placeholder: (_, _) => ColoredBox(color: context.appColors.stroke),
                        errorWidget: (_, _, _) => _placeholder(context),
                      ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: isBusy ? null : onCameraTap,
                  customBorder: const CircleBorder(),
                  child: Ink(
                    width: _fabSize,
                    height: _fabSize,
                    decoration: BoxDecoration(
                      color: context.appColors.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: context.appColors.shadow.withValues(
                            alpha: 0.12,
                          ),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: isBusy
                        ? Padding(
                            padding: const EdgeInsets.all(8),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: context.theme.colorScheme.onPrimary,
                            ),
                          )
                        : Icon(
                            LucideIcons.camera,
                            size: 18,
                            color: context.theme.colorScheme.onPrimary,
                          ),
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
      child: Icon(
        LucideIcons.user,
        color: context.appColors.grey,
        size: 48,
      ),
    );
  }
}
