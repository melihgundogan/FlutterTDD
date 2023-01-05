// https://jsonplaceholder.typicode.com/users

import 'package:test_hwa/home/home_model.dart';
import 'package:vexana/vexana.dart';

abstract class IHomeService {
  late INetworkManager networkManager;

  IHomeService(this.networkManager);

  Future<List<ReqProfile>?> getAllItems();
}

class HomeService implements IHomeService {
  @override
  late INetworkManager<INetworkModel?> networkManager;

  @override
  Future<List<ReqProfile>?> getAllItems() async {
    final response = await networkManager.send<ReqProfile, List<ReqProfile>>('/users',
        parseModel: ReqProfile(), method: RequestType.GET);

    return response.data;
  }
}
