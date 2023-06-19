import 'package:chop/core/failure/failure.dart';
import 'package:chop/domain/model/rescue.dart';
import 'package:chop/domain/repositories/chop_repository.dart';
import 'package:dartz/dartz.dart';

import '../../core/use_case/use_case.dart';

class CreateRescueUseCase implements UseCase<Rescue, CreateRescueParams> {
  final ChopRepository _repo;

  const CreateRescueUseCase(this._repo);

  @override
  Future<Either<Failure, Rescue>> call(CreateRescueParams params) =>
      _repo.createRescue(params);
}

class CreateRescueParams {
  final String code;
  final int fiiId;
  final int vendorId;

  const CreateRescueParams({
    required this.code,
    required this.fiiId,
    required this.vendorId,
  });
}
