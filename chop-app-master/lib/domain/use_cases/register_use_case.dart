import 'package:chop/core/failure/failure.dart';
import 'package:chop/domain/model/user.dart';
import 'package:chop/domain/repositories/chop_repository.dart';
import 'package:dartz/dartz.dart';

import '../../core/use_case/use_case.dart';

class RegisterUseCase implements UseCase<User, RegisterParams> {
  final ChopRepository _repo;

  const RegisterUseCase(this._repo);

  @override
  Future<Either<Failure, User>> call(RegisterParams params) =>
      _repo.register(params);
}

class RegisterParams {
  final String name;
  final String email;
  final String password;
  final String phone;
  final String role;
  final String? location;
  final String? address;

  const RegisterParams({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.role,
    this.location,
    this.address,
  });
}
