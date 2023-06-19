import 'package:bloc/bloc.dart';
import 'package:chop/domain/model/rescue.dart';
import 'package:chop/domain/use_cases/checkout_use_case.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/failure/failure.dart';

part 'checkout_page_state.dart';

class CheckoutPageCubit extends Cubit<CheckoutPageState> {
  final CheckOutUseCase useCase;

  CheckoutPageCubit(this.useCase) : super(CheckoutPageInitial());

  Future<void> checkout(CheckOutParams params) async {
    final result = await useCase.call(params);

    result.fold((l) {
      if (l is UnauthenticatedFailure) {
        emit(CheckoutPageSignOut());
      } else {
        emit(CheckoutPageError(l.errorMessage));
      }
    }, (r) => emit(CheckoutSuccess(r)));
  }

  goToInitial() => emit(CheckoutPageInitial());
}
