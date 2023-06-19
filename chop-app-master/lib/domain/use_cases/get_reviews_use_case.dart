import 'package:chop/core/failure/failure.dart';
import 'package:chop/domain/model/review.dart';
import 'package:chop/domain/repositories/chop_repository.dart';
import 'package:dartz/dartz.dart';

import '../../core/use_case/use_case.dart';

class GetReviewsUseCase implements UseCase<List<Review>, NoParams> {
  final ChopRepository _repo;

  const GetReviewsUseCase(this._repo);

  @override
  Future<Either<Failure, List<Review>>> call(NoParams params) =>
      _repo.getReviews(params);
}
