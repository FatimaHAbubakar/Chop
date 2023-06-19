import 'package:chop/core/failure/failure.dart';
import 'package:chop/domain/model/user.dart';
import 'package:chop/domain/repositories/chop_repository.dart';
import 'package:dartz/dartz.dart';

import '../../core/use_case/use_case.dart';

class LoginUseCase implements UseCase<User, LoginParams> {
  final ChopRepository _repo;

  const LoginUseCase(this._repo);

  @override
  Future<Either<Failure, User>> call(LoginParams params) => _repo.login(params);
}

class LoginParams {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});
}
