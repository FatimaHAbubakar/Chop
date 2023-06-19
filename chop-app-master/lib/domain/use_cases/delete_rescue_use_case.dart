import 'package:chop/core/failure/failure.dart';
import 'package:chop/domain/model/rescue.dart';
import 'package:chop/domain/repositories/chop_repository.dart';
import 'package:dartz/dartz.dart';

import '../../core/use_case/use_case.dart';

class DeleteRescueUseCase implements UseCase<Rescue, DeleteRescueParams> {
  final ChopRepository _repo;

  const DeleteRescueUseCase(this._repo);

  @override
  Future<Either<Failure, Rescue>> call(DeleteRescueParams params) =>
      _repo.deleteRescue(params);
}

class DeleteRescueParams {
  final int rescueId;

  const DeleteRescueParams({required this.rescueId});
}
