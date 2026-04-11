import 'dart:async';

import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/apis.dart';
import 'package:qizlar_academy_mobile/config/di/setup_locator.dart';
import 'package:qizlar_academy_mobile/config/logs/logs.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/bloc/auth_session_cubit.dart';
import 'package:qizlar_academy_mobile/feature/auth/presentation/bloc/auth_session_state.dart';

/// Ro'yxatdan o'tgan sessiya uchun ilova old fonda bo'lganda
/// [UserApis.activityPing] ga har 1 daqiqada `{"duration": 1}` yuboradi.
final class ActivityPingService {
  ActivityPingService(this._dio, this._authSessionCubit);

  final Dio _dio;
  final AuthSessionCubit _authSessionCubit;

  Timer? _timer;
  bool _appInForeground = true;

  bool get _shouldPing {
    final s = _authSessionCubit.state;
    return s.isRegistered && (s.accessToken ?? '').isNotEmpty;
  }

  void setAppInForeground(bool value) {
    _appInForeground = value;
    if (value) {
      start();
    } else {
      stop();
    }
  }

  void onAuthStateChanged() {
    if (_appInForeground) {
      start();
    } else {
      stop();
    }
  }

  void start() {
    _timer?.cancel();
    _timer = null;
    if (!_appInForeground || !_shouldPing) return;

    unawaited(_postPing());
    _timer = Timer.periodic(const Duration(minutes: 1), (_) => unawaited(_postPing()));
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _postPing() async {
    if (!_shouldPing) return;
    try {
      await _dio.post<void>(UserApis.activityPing, data: <String, dynamic>{'duration': 1});
    } catch (e, st) {
      AppLogger.w('Activity ping failed', error: e, stackTrace: st);
    }
  }
}

/// [ActivityPingService] ni ilova lifecycle va auth oqimiga bog'laydi.
class ActivityPingScope extends StatefulWidget {
  const ActivityPingScope({super.key, required this.child});

  final Widget child;

  @override
  State<ActivityPingScope> createState() => _ActivityPingScopeState();
}

class _ActivityPingScopeState extends State<ActivityPingScope> with WidgetsBindingObserver {
  late final ActivityPingService _service = getIt<ActivityPingService>();
  StreamSubscription<AuthSessionState>? _authSub;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _service.setAppInForeground(true);
    _authSub = getIt<AuthSessionCubit>().stream.listen((_) => _service.onAuthStateChanged());
  }

  @override
  void dispose() {
    _authSub?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    _service.stop();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _service.setAppInForeground(true);
    } else if (state == AppLifecycleState.paused) {
      _service.setAppInForeground(false);
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
