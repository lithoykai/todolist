import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:todolist/data/datasource/clients/hive/hive_service.dart';
import 'package:todolist/data/datasource/clients/http/http_service.dart';
import 'package:todolist/data/datasource/user/auth_remote_datasource.dart';
import 'package:todolist/data/datasource/user/auth_remote_datasource_impl.dart';

import '../../../fixture/auth_fixture.dart';
import 'auth_remote_datasource_test.mocks.dart';

@GenerateMocks([HttpService, HiveService])
void main() {
  late HttpService httpService;
  late HiveService hiveService;
  late AuthRemoteDatasource datasource;

  setUp(() {
    httpService = MockHttpService();
    hiveService = MockHiveService();
    datasource = AuthRemoteDatasourceImpl(http: httpService, hive: hiveService);
  });

  group('authentication test', () {
    test('should login', () async {
      final _fixture = fakeAuthDTO;
      final _entity = fakeUserEntity;
      when(httpService.login(_fixture)).thenAnswer((_) async =>
          Response(requestOptions: RequestOptions(), data: authHttpReponse));
      when(hiveService.saveItem('user', 'token', _entity))
          .thenAnswer((_) async {});
      // act
      final response = await datasource.login(_fixture);
      // assert
      verify(httpService.login(_fixture)).called(1);
    });
  });
}
