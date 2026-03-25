import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/profile/domain/model/profile_overview_model.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.user});

  final ProfileUserModel user;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 86,
          height: 86,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: context.appColors.primary, width: 3),
          ),
          child: ClipOval(
            child: CachedNetworkImage(
              imageUrl: user.avatarUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  Container(color: context.appColors.stroke),
              errorWidget: (context, url, error) => Container(
                color: context.appColors.stroke,
                child: Icon(LucideIcons.user, color: context.appColors.grey),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          user.fullName,
          textAlign: TextAlign.center,
          style: context.textTheme.bodyLargeSemibold.copyWith(
            color: context.appColors.text,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'id: ${user.userId}',
          style: context.textTheme.bodySmallRegular.copyWith(
            color: context.appColors.secondaryGrey,
          ),
        ),
      ],
    );
  }
}
