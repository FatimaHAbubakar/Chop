import 'package:chop/core/failure/failure.dart';
import 'package:chop/domain/model/review.dart';
import 'package:chop/domain/repositories/chop_repository.dart';
import 'package:dartz/dartz.dart';

import '../../core/use_case/use_case.dart';

class UpdateReviewUseCase implements UseCase<Review, UpdateReviewParams> {
  final ChopRepository _repo;

  const UpdateReviewUseCase(this._repo);

  @override
  Future<Either<Failure, Review>> call(UpdateReviewParams params) =>
      _repo.updateReview(params);
}

class UpdateReviewParams {
  final int reviewId;
  final int star;

  const UpdateReviewParams({
    required this.reviewId,
    required this.star,
  });
}
