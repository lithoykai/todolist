import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:todolist/domain/entities/user/user_entity.dart';
import 'package:todolist/domain/repositories/user/auth_repository.dart';
import 'package:todolist/domain/usecase/auth/get_user.dart';
import 'package:todolist/infra/failure/failure.dart';

import '../../../fixture/auth_fixture.dart';
import 'create_account_test.mocks.dart';

void main() {
  late GetUserUseCase usecase;
  late AuthRepository repository;

  setUp(() {
    repository = MockAuthRepository();
    usecase = GetUserUseCase(authRepository: repository);
  });

  group('get user use case test', () {
    test('should return user entity when call', () async {
      final _fixtureEntity = fakeUserEntity;
      when(repository.getUser()).thenAnswer((_) async => Right(_fixtureEntity));

      final response = await usecase.call();
      final result = response.fold((l) => l, (r) => r);
      expect(result, _fixtureEntity);
      expect(result, isA<UserEntity>());
      expect(response.isRight(), true);
      verify(repository.getUser());
    });

    test('should return a failure when call signup', () async {
      final _fixtureFailure = AppFailure();
      when(repository.getUser()).thenAnswer((_) async => Left(_fixtureFailure));

      final response = await usecase.call();
      final result = response.fold((l) => l, (r) => r);
      expect(result, _fixtureFailure);
      expect(result, isA<AppFailure>());
      expect(response.isLeft(), true);
      verify(repository.getUser());
    });
  });
}
