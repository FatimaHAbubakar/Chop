import 'package:bloc/bloc.dart';
import 'package:chop/core/use_case/use_case.dart';
import 'package:chop/domain/model/rescue.dart';
import 'package:chop/domain/model/user.dart';
import 'package:chop/domain/use_cases/get_rescue_inventories.dart';
import 'package:chop/domain/use_cases/get_rescues_use_case.dart';
import 'package:chop/domain/use_cases/get_user_use_case.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/failure/failure.dart';
import '../../../../domain/model/rescue_inventory.dart';

part 'fii_rescue_page_state.dart';

class FIIRescuePageCubit extends Cubit<FIIRescuePageState> {
  final GetRescuesUseCase getRescuesUseCase;
  final GetRescueInventoriesUseCase getRescueInventoriesUseCase;
  final GetUserUseCase getUserUseCase;

  FIIRescuePageCubit(this.getRescuesUseCase, this.getRescueInventoriesUseCase,
      this.getUserUseCase)
      : super(FIIRescuePageLoading());

  Future<User?> getUser() async {
    final result = await getUserUseCase.call(NoParams());

    User? user;
    result.fold((l) => emit(FIIRescuePageSignOut()), (r) => user = r);
    return user;
  }

  Future<void> getRescuesAndRescueInventories() async {
    User? user = await getUser();

    if (user == null) return;

    final getRescuesResult =
        await getRescuesUseCase.call(GetRescuesParams(user.role, user.id));
    final getRescueInventoriesResult = await getRescueInventoriesUseCase
        .call(GetRescueInventoriesParams(user.role, user.id));

    getRescuesResult.fold((l) {
      if (l is UnauthenticatedFailure) {
        emit(FIIRescuePageSignOut());
      } else {
        emit(FIIRescuePageError(l.errorMessage));
      }
    }, (rescues) {
      getRescueInventoriesResult.fold((l) {
        if (l is UnauthenticatedFailure) {
          emit(FIIRescuePageSignOut());
        } else {
          emit(FIIRescuePageError(l.errorMessage));
        }
      }, (r) => emit(FIIRescuePageInitial(rescues, r)));
    });
  }
}
