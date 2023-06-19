import 'package:chop/core/failure/failure.dart';
import 'package:chop/domain/model/rescue.dart';
import 'package:chop/domain/repositories/chop_repository.dart';
import 'package:dartz/dartz.dart';

import '../../core/use_case/use_case.dart';

class GetRescueUseCase implements UseCase<Rescue, GetRescueParams> {
  final ChopRepository _repo;

  const GetRescueUseCase(this._repo);

  @override
  Future<Either<Failure, Rescue>> call(GetRescueParams params) =>
      _repo.getRescue(params);
}

class GetRescueParams {
  final int rescueId;

  const GetRescueParams({required this.rescueId});
}
