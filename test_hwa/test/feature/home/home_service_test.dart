import 'package:flutter_test/flutter_test.dart';
import 'package:test_hwa/home/home_model.dart';
import 'package:test_hwa/home/home_service.dart';
import 'package:vexana/vexana.dart';

void main() {
  late INetworkManager<INetworkModel?> networkManager;

  late IHomeService homeService;
  setUp(() {
    networkManager = NetworkManager(
        isEnableLogger: true,
        options: BaseOptions(baseUrl: "https://jsonplaceholder.typicode.com/"));
    homeService = HomeService(networkManager);
  });

  test('Get All List Data', () async {
    final listDatas = await networkManager.send<ReqProfile, List<ReqProfile>>(
        '/users',
        parseModel: ReqProfile(),
        method: RequestType.GET);

    expect(listDatas.data, isNotNull);
  });

  test('Get All List Manager', () async {
    final listDatas = await homeService.getAllItems();

    expect(listDatas, isNotNull);
  });
}
