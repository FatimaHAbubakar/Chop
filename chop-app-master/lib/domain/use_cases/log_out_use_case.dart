import 'package:dartz/dartz.dart';

import '../../core/failure/failure.dart';
import '../../core/use_case/use_case.dart';
import '../repositories/chop_repository.dart';

class LogOutUseCase implements UseCase<void, NoParams> {
  final ChopRepository _repo;

  const LogOutUseCase(this._repo);

  @override
  Future<Either<Failure, void>> call(NoParams params) => _repo.logOut(params);
}
