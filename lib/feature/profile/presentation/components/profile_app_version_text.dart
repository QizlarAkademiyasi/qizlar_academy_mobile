import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';

/// Pastki qatordagi versiya — `pubspec.yaml` dagi `version` / `build-number` (build metama’lumotidan).
class ProfileAppVersionText extends StatefulWidget {
  const ProfileAppVersionText({super.key, required this.style});

  final TextStyle style;

  @override
  State<ProfileAppVersionText> createState() => _ProfileAppVersionTextState();
}

class _ProfileAppVersionTextState extends State<ProfileAppVersionText> {
  late final Future<String> _versionLabelFuture = _resolveVersionLabel();

  static Future<String> _resolveVersionLabel() async {
    final info = await PackageInfo.fromPlatform();
    return '${info.version}+${info.buildNumber}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return FutureBuilder<String>(
      future: _versionLabelFuture,
      builder: (context, snapshot) {
        final label = snapshot.data ?? '...';
        return Text(l10n.profileVersion(label), style: widget.style, textAlign: TextAlign.center);
      },
    );
  }
}
