import 'package:flutter_test/flutter_test.dart';
import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/data/datasource/portfolio_api_datasource.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/domain/model/portfolio_media_model.dart';
import 'package:qizlar_academy_mobile/feature/portfolio/domain/repository/portfolio_repository.dart';

void main() {
  late PortfolioApiDatasource datasource;

  setUp(() {
    datasource = PortfolioApiDatasource(Dio());
  });

  test('parses feed cursor and hasMore', () {
    final page = datasource.parseFeedPayload(
      _feedPayload(items: [_postPayload()]),
    );

    expect(page.nextCursor, 1);
    expect(page.hasMore, isTrue);
    expect(page.items, hasLength(1));
    expect(page.items.first.caption, 'Kurs ishim tayyor!');
  });

  test('parses null author photo as empty URL', () {
    final page = datasource.parseFeedPayload(
      _feedPayload(items: [_postPayload(authorPhoto: null)]),
    );

    expect(page.items.first.author.photoUrl, isEmpty);
  });

  test('parses multiple media items ordered by orderIndex', () {
    final page = datasource.parseFeedPayload(
      _feedPayload(
        items: [
          _postPayload(
            media: [
              _mediaPayload(
                id: 'second',
                orderIndex: 1,
                type: 'VIDEO',
                duration: 30,
              ),
              _mediaPayload(id: 'first', orderIndex: 0),
            ],
          ),
        ],
      ),
    );

    final media = page.items.first.media;
    expect(media, hasLength(2));
    expect(media.first.id, 'first');
    expect(media.last.type, PortfolioMediaType.video);
    expect(media.last.duration, 30);
  });

  test('parses empty feed', () {
    final page = datasource.parseFeedPayload(
      _feedPayload(items: const [], hasMore: false, nextCursor: 0),
    );

    expect(page.items, isEmpty);
    expect(page.hasMore, isFalse);
    expect(page.nextCursor, 0);
  });

  test('parses like response', () {
    final result = datasource.parseLikePayload({
      'statusCode': 200,
      'message': 'OK',
      'data': {'isLiked': true, 'likesCount': 39},
    });

    expect(result.isLiked, isTrue);
    expect(result.likesCount, 39);
  });

  test('parses comment list pagination', () {
    final page = datasource.parseCommentsPayload(_commentsPayload());

    expect(page.items, hasLength(1));
    expect(page.items.first.content, 'Juda ajoyib natija!');
    expect(page.pageNumber, 1);
    expect(page.pageSize, 10);
    expect(page.totalCount, 7);
    expect(page.hasNextPage, isFalse);
  });

  test('create post accepts 204 response', () async {
    final dio = Dio();
    final adapter = _FakeAdapter();
    dio.httpClientAdapter = adapter;
    final api = PortfolioApiDatasource(dio);

    await api.createPost(
      caption: 'Kurs ishim tayyor!',
      media: const [
        PortfolioCreateMediaInput(
          type: PortfolioMediaType.image,
          url: 'https://cdn.example.com/photo.jpg',
          orderIndex: 0,
        ),
      ],
    );

    expect(adapter.lastMethod, 'POST');
    expect(adapter.lastPath, '/api/v1/post');
  });

  test('delete post accepts 204 response', () async {
    final dio = Dio();
    final adapter = _FakeAdapter();
    dio.httpClientAdapter = adapter;
    final api = PortfolioApiDatasource(dio);

    await api.deletePost('post-1');

    expect(adapter.lastMethod, 'DELETE');
    expect(adapter.lastPath, '/api/v1/post/post-1');
  });

  test('add comment accepts 204 response', () async {
    final dio = Dio();
    final adapter = _FakeAdapter();
    dio.httpClientAdapter = adapter;
    final api = PortfolioApiDatasource(dio);

    await api.addComment(postId: 'post-1', content: 'Zo\'r!', parentId: null);

    expect(adapter.lastMethod, 'POST');
    expect(adapter.lastPath, '/api/v1/post/post-1/comment');
  });
}

Map<String, dynamic> _feedPayload({
  required List<Map<String, dynamic>> items,
  int nextCursor = 1,
  bool hasMore = true,
}) {
  return <String, dynamic>{
    'statusCode': 200,
    'message': 'OK',
    'data': <String, dynamic>{
      'data': items,
      'nextCursor': nextCursor,
      'hasMore': hasMore,
    },
  };
}

Map<String, dynamic> _postPayload({
  String? authorPhoto,
  List<Map<String, dynamic>>? media,
}) {
  return <String, dynamic>{
    'id': 'post-1',
    'caption': 'Kurs ishim tayyor!',
    'viewsCount': 382,
    'likesCount': 79,
    'commentsCount': 12,
    'createdAt': '2026-06-24T10:07:04.294Z',
    'author': <String, dynamic>{
      'id': 'author-1',
      'firstname': 'Dilshoda',
      'lastname': 'Mavlonova',
      'photo': authorPhoto,
    },
    'media': media ?? [_mediaPayload()],
    'isLiked': false,
  };
}

Map<String, dynamic> _mediaPayload({
  String id = 'media-1',
  String type = 'IMAGE',
  int orderIndex = 0,
  int? duration,
}) {
  return <String, dynamic>{
    'id': id,
    'type': type,
    'url': 'https://picsum.photos/seed/$id/800/600',
    'thumbnail': null,
    'duration': duration,
    'orderIndex': orderIndex,
  };
}

Map<String, dynamic> _commentsPayload() {
  return <String, dynamic>{
    'statusCode': 200,
    'message': 'OK',
    'data': <String, dynamic>{
      'data': [
        <String, dynamic>{
          'id': 'comment-1',
          'content': 'Juda ajoyib natija!',
          'parentId': null,
          'createdAt': '2026-06-24T10:15:00.000Z',
          'author': <String, dynamic>{
            'id': 'author-2',
            'firstname': 'Dilnoza',
            'lastname': 'Rahimova',
            'photo': null,
          },
        },
      ],
      'meta': <String, dynamic>{
        'pagination': <String, dynamic>{
          'pageNumber': 1,
          'pageSize': 10,
          'count': 7,
          'pageCount': 1,
        },
      },
    },
  };
}

class _FakeAdapter implements HttpClientAdapter {
  String? lastMethod;
  String? lastPath;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastMethod = options.method;
    lastPath = options.path;
    return ResponseBody.fromString('', 204);
  }
}
