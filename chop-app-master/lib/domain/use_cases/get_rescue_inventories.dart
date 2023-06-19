import 'package:chop/core/failure/failure.dart';
import 'package:chop/domain/model/rescue_inventory.dart';
import 'package:chop/domain/repositories/chop_repository.dart';
import 'package:dartz/dartz.dart';

import '../../core/use_case/use_case.dart';

class GetRescueInventoriesUseCase
    implements UseCase<List<RescueInventory>, GetRescueInventoriesParams> {
  final ChopRepository _repo;

  const GetRescueInventoriesUseCase(this._repo);

  @override
  Future<Either<Failure, List<RescueInventory>>> call(
          GetRescueInventoriesParams params) =>
      _repo.getRescueInventories(params);
}

class GetRescueInventoriesParams {
  final String role;
  final int userId;

  const GetRescueInventoriesParams(this.role, this.userId);
}
