import 'package:bloc/bloc.dart';
import 'package:chop/core/failure/failure.dart';
import 'package:chop/core/use_case/use_case.dart';
import 'package:chop/domain/model/review.dart';
import 'package:chop/domain/model/user.dart';
import 'package:chop/domain/use_cases/get_reviews_use_case.dart';
import 'package:chop/domain/use_cases/get_vendors_use_case.dart';
import 'package:equatable/equatable.dart';

part 'fii_home_page_state.dart';

class FIIHomePageCubit extends Cubit<FIIHomePageState> {
  final GetVendorsUseCase getVendorsUseCase;
  final GetReviewsUseCase getReviewsUseCase;

  FIIHomePageCubit(this.getVendorsUseCase, this.getReviewsUseCase)
      : super(FIIHomePageLoading());

  Future<void> getVendorsAndReviews(NoParams params) async {
    final getVendorsResult = await getVendorsUseCase.call(params);
    final getReviewsResult = await getReviewsUseCase.call(params);

    getVendorsResult.fold((l) {
      if (l is UnauthenticatedFailure) {
        emit(FIIHomePageSignOut());
      } else {
        emit(FIIHomePageError(l.errorMessage));
      }
    }, (vendors) {
      getReviewsResult.fold((l) {
        if (l is UnauthenticatedFailure) {
          emit(FIIHomePageSignOut());
        } else {
          emit(FIIHomePageError(l.errorMessage));
        }
      }, (r) => emit(FIIHomePageInitial(vendors, r)));
    });
  }
}
