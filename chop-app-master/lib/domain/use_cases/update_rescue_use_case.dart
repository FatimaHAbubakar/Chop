import 'package:chop/core/failure/failure.dart';
import 'package:chop/domain/model/rescue.dart';
import 'package:chop/domain/repositories/chop_repository.dart';
import 'package:dartz/dartz.dart';

import '../../core/use_case/use_case.dart';

class UpdateRescueUseCase implements UseCase<Rescue, UpdateRescueParams> {
  final ChopRepository _repo;

  const UpdateRescueUseCase(this._repo);

  @override
  Future<Either<Failure, Rescue>> call(UpdateRescueParams params) =>
      _repo.updateRescue(params);
}

class UpdateRescueParams {
  final int rescueId;
  final int quantity;

  const UpdateRescueParams({
    required this.rescueId,
    required this.quantity,
  });
}
