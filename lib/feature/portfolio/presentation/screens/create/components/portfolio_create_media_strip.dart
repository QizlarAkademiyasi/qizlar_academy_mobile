import 'dart:io';

import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/domain/model/portfolio_media_model.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/presentation/screens/create/bloc/portfolio_create_bloc.dart';

class PortfolioCreateMediaStrip extends StatelessWidget {
  const PortfolioCreateMediaStrip({
    super.key,
    required this.media,
    required this.onRemove,
  });

  final List<PortfolioPickedMedia> media;
  final ValueChanged<int> onRemove;

  @override
  Widget build(BuildContext context) {
    if (media.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: 390,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: media.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final item = media[index];
          return SizedBox(
            width: media.length == 1 ? 296 : 266,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(File(item.localFilePath), fit: BoxFit.cover),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: InkWell(
                      onTap: () => onRemove(index),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.black.withValues(alpha: 0.52),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          LucideIcons.x,
                          size: 18,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                  if (item.type == PortfolioMediaType.video)
                    Center(
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: AppColors.black.withValues(alpha: 0.45),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          LucideIcons.play,
                          color: AppColors.white,
                          size: 20,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
