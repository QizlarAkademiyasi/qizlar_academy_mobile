import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/app_padding.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/notification/domain/model/notification_item_model.dart';
import 'package:qizlar_academy_mobile/feature/notification/presentation/components/notification_tile.dart';

class NotificationSection extends StatelessWidget {
  const NotificationSection({
    super.key,
    required this.section,
    required this.onItemTap,
  });

  final NotificationSectionModel section;
  final ValueChanged<NotificationItemModel> onItemTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: AppPadding.paddingHorizontalMd,
          child: Text(
            section.title,
            style: context.textTheme.heading6.copyWith(
              color: context.appColors.text,
            ),
          ),
        ),
        const SizedBox(height: 10),
        ...List.generate(section.items.length, (index) {
          final item = section.items[index];
          return NotificationTile(
            item: item,
            onTap: () => onItemTap(item),
            showDivider: index != section.items.length - 1,
          );
        }),
      ],
    );
  }
}
