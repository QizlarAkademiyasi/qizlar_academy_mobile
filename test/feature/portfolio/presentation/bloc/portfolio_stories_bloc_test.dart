import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/category_model.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/repository/home_repository.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/presentation/bloc/portfolio_stories_bloc.dart';

class _Repository implements HomeRepository {
  bool fail = false;
  int loads = 0;
  final views = <String>[];
  @override
  Future<List<StoryModel>> getCategories() async {
    loads++;
    if (fail) throw Exception('offline');
    return const [
      StoryModel(id: '1', name: 'Story', imageUrl: '', thumbnailUrl: ''),
      StoryModel(
        id: 'birthday',
        name: 'Birthday',
        imageUrl: '',
        thumbnailUrl: '',
        canTrackView: false,
      ),
    ];
  }

  @override
  Future<void> postStoryView(String id) async {
    views.add(id);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test(
    'loads independently, tracks a story once, skips synthetic stories',
    () async {
      final repo = _Repository();
      final bloc = PortfolioStoriesBloc(repo);
      addTearDown(bloc.close);
      final loaded = bloc.stream.firstWhere(
        (s) => s.status == PortfolioStoriesStatus.success,
      );
      bloc.add(const PortfolioStoriesStarted());
      await loaded;
      expect(repo.loads, 1);
      bloc.add(const PortfolioStoryViewed('1'));
      bloc.add(const PortfolioStoryViewed('1'));
      bloc.add(const PortfolioStoryViewed('birthday'));
      await Future<void>.delayed(Duration.zero);
      expect(repo.views, ['1']);
      expect(bloc.state.viewedIds, {'1'});
    },
  );
  test('story failure can retry', () async {
    final repo = _Repository()..fail = true;
    final bloc = PortfolioStoriesBloc(repo);
    addTearDown(bloc.close);
    final failed = bloc.stream.firstWhere(
      (s) => s.status == PortfolioStoriesStatus.failure,
    );
    bloc.add(const PortfolioStoriesStarted());
    await failed;
    repo.fail = false;
    final loaded = bloc.stream.firstWhere(
      (s) => s.status == PortfolioStoriesStatus.success,
    );
    bloc.add(const PortfolioStoriesStarted());
    await loaded;
    expect(bloc.state.items.length, 2);
  });
}
