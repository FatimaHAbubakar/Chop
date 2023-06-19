import 'package:chop/core/failure/failure.dart';
import 'package:chop/domain/model/review.dart';
import 'package:chop/domain/repositories/chop_repository.dart';
import 'package:dartz/dartz.dart';

import '../../core/use_case/use_case.dart';

class GetReviewUseCase implements UseCase<Review, GetReviewParams> {
  final ChopRepository _repo;

  const GetReviewUseCase(this._repo);

  @override
  Future<Either<Failure, Review>> call(GetReviewParams params) =>
      _repo.getReview(params);
}

class GetReviewParams {
  final int reviewId;

  const GetReviewParams({required this.reviewId});
}
