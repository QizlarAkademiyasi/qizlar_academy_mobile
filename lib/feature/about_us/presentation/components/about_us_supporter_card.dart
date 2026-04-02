import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';

class AboutUsSupporterCard extends StatelessWidget {
  const AboutUsSupporterCard({super.key, required this.name, required this.role, required this.imageUrl});

  final String name;
  final String role;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final hasPhoto = imageUrl.trim().isNotEmpty;
    final initial = name.isNotEmpty ? name.trim()[0].toUpperCase() : '?';

    return Container(
      width: 260,
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 16),
      decoration: BoxDecoration(
        color: context.appColors.onContainer,
        borderRadius: AppRadius.radiusLg,
        border: Border.all(color: context.appColors.stroke),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 128,
            height: 128,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.appColors.stroke,
              border: Border.all(color: context.appColors.stroke, width: 1),
            ),
            clipBehavior: Clip.antiAlias,
            child: hasPhoto
                ? AppCachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (_, _) => _avatarPlaceholder(context, initial),
                    errorWidget: (_, _, _) => _avatarPlaceholder(context, initial),
                  )
                : _avatarPlaceholder(context, initial),
          ),
          const SizedBox(height: 12),
          Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.heading6.copyWith(color: context.appColors.text),
          ),
          const SizedBox(height: 6),
          Text(
            role,
            textAlign: TextAlign.center,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.bodyMediumRegular.copyWith(color: context.appColors.secondaryGrey, height: 1.35),
          ),
        ],
      ),
    );
  }

  Widget _avatarPlaceholder(BuildContext context, String letter) {
    return ColoredBox(
      color: context.appColors.stroke,
      child: Center(
        child: Text(letter, style: context.textTheme.heading6.copyWith(color: context.appColors.grey)),
      ),
    );
  }
}
