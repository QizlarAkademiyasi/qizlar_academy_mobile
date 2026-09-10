import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/feature/announcement/domain/model/announcement_model.dart';
import 'package:qizlar_academy_mobile/feature/announcement/domain/repository/announcement_repository.dart';
import 'package:qizlar_academy_mobile/feature/announcement/presentation/services/announcement_session_coordinator.dart';

void main() {
  testWidgets('fetches first after the initial delay and follows hasMore', (
    tester,
  ) async {
    final repository = _FakeAnnouncementRepository([
      const AnnouncementNextResult(announcement: _announcement, hasMore: true),
      const AnnouncementNextResult(announcement: null, hasMore: false),
    ]);
    var presented = 0;
    late AnnouncementSessionCoordinator coordinator;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            coordinator = AnnouncementSessionCoordinator(
              repository,
              initialDelay: const Duration(seconds: 1),
              nextDelay: const Duration(seconds: 2),
              presenter: (_, _) async {
                presented++;
                return null;
              },
            )..start(context);
            return const SizedBox();
          },
        ),
      ),
    );

    await tester.pump(const Duration(milliseconds: 999));
    expect(repository.fetchCalls, 0);

    await tester.pump(const Duration(milliseconds: 1));
    await tester.pump();
    expect(repository.fetchCalls, 1);
    expect(presented, 1);

    await tester.pump(const Duration(seconds: 2));
    await tester.pump();
    expect(repository.fetchCalls, 2);
    expect(presented, 1);

    coordinator.stop();
  });

  testWidgets('stop cancels the pending initial request', (tester) async {
    final repository = _FakeAnnouncementRepository(const []);
    late AnnouncementSessionCoordinator coordinator;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            coordinator = AnnouncementSessionCoordinator(
              repository,
              initialDelay: const Duration(seconds: 1),
              presenter: (_, _) async => null,
            )..start(context);
            return const SizedBox();
          },
        ),
      ),
    );

    coordinator.stop();
    await tester.pump(const Duration(seconds: 2));

    expect(repository.fetchCalls, 0);
  });
}

const _announcement = AnnouncementModel(
  viewId: 'view-1',
  type: AnnouncementType.course,
  photoUrl: 'https://cdn.example.com/banner.png',
  courseId: 'course-1',
);

class _FakeAnnouncementRepository implements AnnouncementRepository {
  _FakeAnnouncementRepository(this._results);

  final List<AnnouncementNextResult> _results;
  var fetchCalls = 0;

  @override
  Future<AnnouncementNextResult> fetchNext() async {
    final index = fetchCalls++;
    return _results[index];
  }

  @override
  Future<void> markClicked(String viewId) async {}
}
