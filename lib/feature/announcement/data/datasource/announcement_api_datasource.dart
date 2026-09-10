import 'package:qizlar_academy_kit/qizlar_academy_kit.dart';
import 'package:qizlar_academy_mobile/config/constants/apis.dart';
import 'package:qizlar_academy_mobile/feature/announcement/data/datasource/announcement_datasource.dart';
import 'package:qizlar_academy_mobile/feature/announcement/domain/model/announcement_model.dart';

class AnnouncementApiDatasource implements AnnouncementDatasource {
  const AnnouncementApiDatasource(this._dio);

  final Dio _dio;

  @override
  Future<AnnouncementNextResult> fetchNext() async {
    final response = await _dio.get<dynamic>(UserApis.announcementNext);
    return parseNextResponse(response.data);
  }

  @override
  Future<void> markClicked(String viewId) async {
    final id = viewId.trim();
    if (id.isEmpty) return;
    await _dio.patch<dynamic>(UserApis.announcementClick(id));
  }

  AnnouncementNextResult parseNextResponse(dynamic raw) {
    final envelope = _asMap(raw);
    final data = _asMap(envelope['data']);
    final rawAnnouncement = data['announcement'];

    return AnnouncementNextResult(
      announcement: rawAnnouncement is Map
          ? _parseAnnouncement(_asMap(rawAnnouncement))
          : null,
      hasMore: _asBool(data['hasMore']),
    );
  }

  AnnouncementModel _parseAnnouncement(Map<String, dynamic> map) {
    return AnnouncementModel(
      viewId: (map['viewId'] ?? '').toString().trim(),
      type: AnnouncementType.fromApi(map['type']),
      photoUrl: Apis.resolveUrl((map['photo'] ?? '').toString()),
      link: _nullableString(map['link']),
      courseId: _nullableString(map['courseId']),
      courseName: _nullableString(map['courseName']),
    );
  }

  Map<String, dynamic> _asMap(dynamic raw) {
    if (raw is Map<String, dynamic>) return raw;
    if (raw is Map) {
      return raw.map((key, value) => MapEntry(key.toString(), value));
    }
    return <String, dynamic>{};
  }

  String? _nullableString(dynamic value) {
    final text = value?.toString().trim() ?? '';
    return text.isEmpty ? null : text;
  }

  bool _asBool(dynamic value) {
    if (value is bool) return value;
    return value?.toString().trim().toLowerCase() == 'true';
  }
}
