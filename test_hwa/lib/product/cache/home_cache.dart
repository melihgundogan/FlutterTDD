import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../home/home_model.dart';

abstract class IHomeCache {
  Future<bool>? saveModel(ReqProfile model) {}

  Future<ReqProfile?> getModel();
  Future<bool> removeModel();
  Future<ReqProfile?> getModelWithoutExpiry();
  int durationTime = 5;

  IHomeCache({int? durationTime}) {
    this.durationTime = durationTime ?? 5;
  }
}

class HomeCacheShared extends IHomeCache {
  SharedPreferences? prefs;

  HomeCacheShared({int? time}) : super(durationTime: time);

  @override
  Future<ReqProfile?> getModel() async {
    prefs = await SharedPreferences.getInstance();
    final _modelValues = prefs!.getString(runtimeType.toString());
    if (_modelValues == null) return null;

    final jsonBody = jsonDecode(_modelValues);
    return ReqProfile.fromJson(jsonBody);
  }

  @override
  Future<bool> saveModel(ReqProfile model) async {
    prefs = await SharedPreferences.getInstance();
    model.expiryTime = DateTime.now()
        .add(Duration(milliseconds: durationTime))
        .toIso8601String();
    final modelValues = jsonEncode(model);
    return await prefs!.setString(runtimeType.toString(), modelValues) ??
        false;
  }

  @override
  Future<bool> removeModel() async {
    prefs = await SharedPreferences.getInstance();
    return await prefs?.remove(runtimeType.toString()) ?? false;
  }

  Future<ReqProfile?> getModelWithoutExpiry() async {
    final data = await getModel();
    if (data != null) return data.isExpiry() ? null : data;
    return null;
  }
}
