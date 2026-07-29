import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/enum/user_type.dart';
import 'package:qizlar_academy_mobile/config/flavor/env_config.dart';
import 'package:qizlar_academy_mobile/feature/home/data/datasource/home_api_datasource.dart';
import 'package:qizlar_academy_mobile/feature/home/domain/model/category_model.dart';

void main() {
  late HomeApiDatasource datasource;

  setUp(() {
    datasource = HomeApiDatasource(Dio());
  });

  test('parses birthday type and its dedicated thumbnail', () {
    final stories = datasource.parseStoriesPayload({
      'data': {
        'data': [
          {
            'id': 'birthday-user-id',
            'title': null,
            'mediaUrl': 'https://cdn.example.com/profile.jpg',
            'thumbnail': 'https://cdn.example.com/profile-thumb.webp',
            'isViewed': false,
            'type': 'birthday',
          },
        ],
      },
    });

    expect(stories, hasLength(1));
    expect(stories.single.type, StoryItemType.birthday);
    expect(stories.single.isBirthday, isTrue);
    expect(stories.single.canTrackView, isFalse);
    expect(
      stories.single.thumbnailUrl,
      'https://cdn.example.com/profile-thumb.webp',
    );
  });

  test('falls back to mediaUrl when thumbnail is missing', () {
    final stories = datasource.parseStoriesPayload({
      'data': {
        'data': [
          {
            'id': 'story-id',
            'title': 'Yangi kurs',
            'mediaUrl': 'https://cdn.example.com/story.jpg',
            'thumbnail': null,
            'isViewed': true,
            'type': 'story',
          },
        ],
      },
    });

    expect(stories.single.type, StoryItemType.story);
    expect(stories.single.canTrackView, isTrue);
    expect(stories.single.isViewed, isTrue);
    expect(stories.single.thumbnailUrl, 'https://cdn.example.com/story.jpg');
  });

  test('prepends one birthday mock in dev flavor', () async {
    EnvConfig.initialize(
      appName: 'Qizlar Akademiyasi (Dev)',
      flavor: AppFlavors.dev,
    );
    final dio = Dio()..httpClientAdapter = _EmptyStoriesAdapter();
    final stories = await HomeApiDatasource(
      dio,
    ).getCategoriesByUserType(UserType.user);

    expect(stories, hasLength(1));
    expect(stories.single.id, 'dev-birthday-mock');
    expect(stories.single.type, StoryItemType.birthday);
  });

  test('does not add birthday mock in prod flavor', () async {
    EnvConfig.initialize(
      appName: 'Qizlar Akademiyasi',
      flavor: AppFlavors.prod,
    );
    final dio = Dio()..httpClientAdapter = _EmptyStoriesAdapter();
    final stories = await HomeApiDatasource(
      dio,
    ).getCategoriesByUserType(UserType.user);

    expect(stories, isEmpty);
  });
}

class _EmptyStoriesAdapter implements HttpClientAdapter {
  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    return ResponseBody.fromString(
      '{"data":{"data":[]}}',
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }
}
