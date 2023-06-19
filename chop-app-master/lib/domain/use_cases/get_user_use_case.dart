import 'package:chop/domain/model/user.dart';
import 'package:dartz/dartz.dart';

import '../../core/failure/failure.dart';
import '../../core/use_case/use_case.dart';
import '../repositories/chop_repository.dart';

class GetUserUseCase implements UseCase<User, NoParams> {
  final ChopRepository _repo;

  const GetUserUseCase(this._repo);

  @override
  Future<Either<Failure, User>> call(NoParams params) => _repo.getUser(params);
}
