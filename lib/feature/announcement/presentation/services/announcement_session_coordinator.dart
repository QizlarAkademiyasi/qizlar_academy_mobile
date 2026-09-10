import 'dart:async';

import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/l10n/l10n.dart';
import 'package:qizlar_academy_mobile/config/logs/logs.dart';
import 'package:qizlar_academy_mobile/config/router/app_routes.dart';
import 'package:qizlar_academy_mobile/core/presentation/components/app_components.dart';
import 'package:qizlar_academy_mobile/feature/announcement/domain/model/announcement_model.dart';
import 'package:qizlar_academy_mobile/feature/announcement/domain/repository/announcement_repository.dart';
import 'package:qizlar_academy_mobile/feature/announcement/presentation/components/announcement_bottom_sheet.dart';

typedef AnnouncementSheetPresenter =
    Future<AnnouncementSheetAction?> Function(
      BuildContext context,
      AnnouncementModel announcement,
    );

class AnnouncementSessionCoordinator {
  AnnouncementSessionCoordinator(
    this._repository, {
    this.initialDelay = const Duration(seconds: 10),
    this.nextDelay = const Duration(minutes: 10),
    AnnouncementSheetPresenter? presenter,
  }) : _presenter = presenter ?? showAnnouncementBottomSheet;

  final AnnouncementRepository _repository;
  final Duration initialDelay;
  final Duration nextDelay;
  final AnnouncementSheetPresenter _presenter;

  Timer? _timer;
  bool _stopped = false;
  bool _requestInFlight = false;

  void start(BuildContext context) {
    if (_stopped || _timer != null || _requestInFlight) return;
    _schedule(context, initialDelay);
  }

  void stop() {
    _stopped = true;
    _timer?.cancel();
    _timer = null;
  }

  void _schedule(BuildContext context, Duration delay) {
    if (_stopped) return;
    _timer?.cancel();
    _timer = Timer(delay, () {
      _timer = null;
      unawaited(_fetchAndPresent(context));
    });
  }

  Future<void> _fetchAndPresent(BuildContext context) async {
    if (_stopped || _requestInFlight || !context.mounted) return;
    _requestInFlight = true;

    late final AnnouncementNextResult result;
    try {
      result = await _repository.fetchNext();
    } catch (error, stackTrace) {
      AppLogger.e(
        'AnnouncementSessionCoordinator: next announcement failed',
        error: error,
        stackTrace: stackTrace,
      );
      stop();
      return;
    } finally {
      _requestInFlight = false;
    }

    if (_stopped || !context.mounted) return;
    final announcement = result.announcement;
    if (announcement == null) {
      stop();
      return;
    }

    final action = await _presenter(context, announcement);
    if (result.hasMore && !_stopped && context.mounted) {
      _schedule(context, nextDelay);
    }
    if (action != AnnouncementSheetAction.open || !context.mounted) return;

    try {
      await _repository.markClicked(announcement.viewId);
    } catch (error, stackTrace) {
      AppLogger.e(
        'AnnouncementSessionCoordinator: click acknowledgement failed',
        error: error,
        stackTrace: stackTrace,
      );
    }

    if (!context.mounted) return;
    await _openTarget(context, announcement);
  }

  Future<void> _openTarget(
    BuildContext context,
    AnnouncementModel announcement,
  ) async {
    if (announcement.type == AnnouncementType.course) {
      final courseId = announcement.courseId?.trim() ?? '';
      if (courseId.isNotEmpty) {
        context.push(Routes.courseDetails(courseId));
      }
      return;
    }

    var link = announcement.link?.trim() ?? '';
    if (link.isEmpty) return;
    if (!link.contains('://')) link = 'https://$link';
    final uri = Uri.tryParse(link);
    if (uri == null ||
        !(uri.isScheme('http') || uri.isScheme('https')) ||
        !await canLaunchUrl(uri)) {
      if (context.mounted) {
        AppToast.error(context, message: context.l10n.aboutUsLinkOpenError);
      }
      return;
    }

    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && context.mounted) {
      AppToast.error(context, message: context.l10n.aboutUsLinkOpenError);
    }
  }
}
