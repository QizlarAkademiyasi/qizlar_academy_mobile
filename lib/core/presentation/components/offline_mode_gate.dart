import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/core/network/network_status_service.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/offline_screen.dart';

class OfflineModeGate extends StatelessWidget {
  const OfflineModeGate({
    super.key,
    required this.service,
    required this.child,
  });

  final NetworkStatusService service;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: service,
      builder: (context, _) {
        if (!service.isOffline) return child;
        return Stack(
          fit: StackFit.expand,
          children: [
            ExcludeSemantics(child: child),
            OfflineScreen(onRetry: service.refresh),
          ],
        );
      },
    );
  }
}
