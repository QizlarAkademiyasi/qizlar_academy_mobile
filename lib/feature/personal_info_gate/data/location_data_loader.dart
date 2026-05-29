import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:qizlar_academy_mobile/feature/personal_info_gate/domain/model/district_model.dart';
import 'package:qizlar_academy_mobile/feature/personal_info_gate/domain/model/neighborhood_model.dart';
import 'package:qizlar_academy_mobile/feature/personal_info_gate/domain/model/region_model.dart';

/// JSON asset'lardan viloyat, tuman va mahalla ma'lumotlarini yuklaydi.
class LocationDataLoader {
  List<RegionModel>? _cachedRegions;
  List<DistrictModel>? _cachedDistricts;
  List<NeighborhoodModel>? _cachedNeighborhoods;

  Future<List<RegionModel>> loadRegions() async {
    if (_cachedRegions != null) return _cachedRegions!;
    final raw = await rootBundle.loadString('packages/qizlar_academy_kit/assets/data/regions.json');
    final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    _cachedRegions = list.map(RegionModel.fromJson).toList();
    return _cachedRegions!;
  }

  Future<List<DistrictModel>> loadDistricts() async {
    if (_cachedDistricts != null) return _cachedDistricts!;
    final raw = await rootBundle.loadString('packages/qizlar_academy_kit/assets/data/districts.json');
    final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    _cachedDistricts = list.map(DistrictModel.fromJson).toList();
    return _cachedDistricts!;
  }

  Future<List<NeighborhoodModel>> loadNeighborhoods() async {
    if (_cachedNeighborhoods != null) return _cachedNeighborhoods!;
    final raw = await rootBundle.loadString('packages/qizlar_academy_kit/assets/data/neighborhoods.json');
    final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    _cachedNeighborhoods = list.map(NeighborhoodModel.fromJson).toList();
    return _cachedNeighborhoods!;
  }

  Future<List<DistrictModel>> getDistrictsByRegion(int regionId) async {
    final all = await loadDistricts();
    return all.where((d) => d.regionId == regionId).toList();
  }

  Future<List<NeighborhoodModel>> getNeighborhoodsByDistrict(int districtId) async {
    final all = await loadNeighborhoods();
    return all.where((n) => n.districtId == districtId).toList();
  }
}
