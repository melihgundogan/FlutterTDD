import 'package:flutter/material.dart';

import '../product/cache/home_cache.dart';
import 'home_model.dart';
import 'home_service.dart';

typedef UIUpdate = void Function(VoidCallback fn);
// ignore: prefer_generic_function_type_aliases
typedef void SnackBarShow();

abstract class IHomeViewModel {
  final UIUpdate viewUpdate;
  final SnackBarShow snackBarShow;
  Color? backgroundColor = Colors.white;
  IHomeService homeService;
  IHomeCache homeCache;
  bool isLoading = true;
  String? title;
  List<ReqProfile> reqProfiles = [];

  void changeColor(Color color);
  void changeLoading();
  void fetchAllDatas();
  void initCacheData();
  Future<void> cacheItItem(ReqProfile profile);

  IHomeViewModel(this.viewUpdate, this.homeCache, this.homeService, this.snackBarShow);
}

class HomeViewModel extends IHomeViewModel {
  HomeViewModel(UIUpdate viewUpdate, IHomeCache homeCache, IHomeService homeService, SnackBarShow snackBarShow)
      : super(viewUpdate, homeCache, homeService, snackBarShow) {
    initCacheData();
  }

  @override
  void changeColor(Color color) {
    backgroundColor = color;
    viewUpdate(() {});
  }

  @override
  void changeLoading() {
    isLoading = !isLoading;
    viewUpdate(() {});
  }

  @override
  Future<void> fetchAllDatas() async {
    final data = await homeService.getAllItems();
    if (data != null) reqProfiles = data;
    changeLoading();
  }

  @override
  Future<void> initCacheData() async {
    final data = await homeCache.getModelWithoutExpiry();
    if (data != null) {
      title = '${data.name} - ${data.username}';
      viewUpdate(() {});
    }
  }

  @override
  Future<void> cacheItItem(ReqProfile profile) async {
    if (await homeCache.saveModel(profile)) {
      title = profile.name;
      snackBarShow();
      viewUpdate(() {});
    }
  }
}