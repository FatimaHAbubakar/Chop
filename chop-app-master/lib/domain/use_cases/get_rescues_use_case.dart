import 'package:chop/core/failure/failure.dart';
import 'package:chop/domain/model/rescue.dart';
import 'package:chop/domain/repositories/chop_repository.dart';
import 'package:dartz/dartz.dart';

import '../../core/use_case/use_case.dart';

class GetRescuesUseCase implements UseCase<List<Rescue>, GetRescuesParams> {
  final ChopRepository _repo;

  const GetRescuesUseCase(this._repo);

  @override
  Future<Either<Failure, List<Rescue>>> call(GetRescuesParams params) =>
      _repo.getRescues(params);
}

class GetRescuesParams {
  final String role;
  final int userId;

  const GetRescuesParams(this.role, this.userId);
}
