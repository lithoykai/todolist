import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:todolist/domain/entities/user/user_entity.dart';
import 'package:todolist/domain/repositories/user/auth_repository.dart';
import 'package:todolist/domain/usecase/auth/create_account.dart';
import 'package:todolist/infra/failure/failure.dart';

import '../../../fixture/auth_fixture.dart';
import 'create_account_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late CreateAccountUseCase usecase;
  late AuthRepository repository;

  setUp(() {
    repository = MockAuthRepository();
    usecase = CreateAccountUseCase(authRepository: repository);
  });

  group('create account test', () {
    test('should return user entity when call signUp', () async {
      final _fixture = fakeAuthDTO;
      final _fixtureEntity = fakeUserEntity;
      when(repository.signUp(_fixture))
          .thenAnswer((_) async => Right(_fixtureEntity));

      final response = await usecase(_fixture);
      final result = response.fold((l) => l, (r) => r);
      expect(result, _fixtureEntity);
      expect(result, isA<UserEntity>());
      expect(response.isRight(), true);
      verify(repository.signUp(_fixture));
    });

    test('should return a failure when call signup', () async {
      final _fixture = fakeAuthDTO;
      final _fixtureFailure = AuthFailure();
      when(repository.signUp(_fixture))
          .thenAnswer((_) async => Left(_fixtureFailure));

      final response = await usecase.call(_fixture);
      final result = response.fold((l) => l, (r) => r);
      expect(result, _fixtureFailure);
      expect(result, isA<AuthFailure>());
      expect(response.isLeft(), true);
      verify(repository.signUp(_fixture));
    });
  });
}
