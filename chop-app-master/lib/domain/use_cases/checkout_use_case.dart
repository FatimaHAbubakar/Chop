import 'package:chop/core/failure/failure.dart';
import 'package:chop/domain/model/rescue.dart';
import 'package:chop/domain/model/user.dart';
import 'package:chop/domain/repositories/chop_repository.dart';
import 'package:dartz/dartz.dart';

import '../../core/use_case/use_case.dart';

class CheckOutUseCase implements UseCase<Rescue, CheckOutParams> {
  final ChopRepository _repo;

  const CheckOutUseCase(this._repo);

  @override
  Future<Either<Failure, Rescue>> call(CheckOutParams params) =>
      _repo.checkOut(params);
}

class CheckOutParams {
  final Map<String, dynamic> foods;
  final User vendor;

  const CheckOutParams(this.foods, this.vendor);
}
