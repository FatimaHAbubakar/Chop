import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chop/domain/use_cases/get_rescue_inventories.dart';
import 'package:chop/domain/use_cases/get_rescues_use_case.dart';
import 'package:chop/domain/use_cases/get_user_use_case.dart';
import 'package:chop/domain/use_cases/verify_code_use_case.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/failure/failure.dart';
import '../../../../core/use_case/use_case.dart';
import '../../../../domain/model/rescue.dart';
import '../../../../domain/model/rescue_inventory.dart';
import '../../../../domain/model/user.dart';

part 'vendor_rescue_page_state.dart';

class VendorRescuePageCubit extends Cubit<VendorRescuePageState> {
  final GetRescuesUseCase getRescuesUseCase;
  final GetRescueInventoriesUseCase getRescueInventoriesUseCase;
  final GetUserUseCase getUserUseCase;
  final VerifyCodeUseCase verifyCodeUseCase;

  VendorRescuePageCubit(
      this.getRescuesUseCase,
      this.getRescueInventoriesUseCase,
      this.getUserUseCase,
      this.verifyCodeUseCase)
      : super(VendorRescuePageLoading());

  Future<User?> getUser() async {
    final result = await getUserUseCase.call(NoParams());

    User? user;
    result.fold((l) => emit(VendorRescuePageSignOut()), (r) => user = r);
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
        emit(VendorRescuePageSignOut());
      } else {
        emit(VendorRescuePageError(l.errorMessage));
      }
    }, (rescues) {
      getRescueInventoriesResult.fold((l) {
        if (l is UnauthenticatedFailure) {
          emit(VendorRescuePageSignOut());
        } else {
          emit(VendorRescuePageError(l.errorMessage));
        }
      }, (r) => emit(VendorRescuePageInitial(rescues, r)));
    });
  }

  Future<void> verifyCode(String code, int rescueId) async {
    final result = await verifyCodeUseCase
        .call(VerifyCodeParams(rescueId: rescueId, code: code));

    int unauthenticated = 0;

    result.fold((l) {
      if (l is UnauthenticatedFailure) {
        if (unauthenticated >= 1) {
          emit(VendorRescuePageSignOut());
        }
        unauthenticated++;
      } else {
        emit(VendorRescuePageError(l.errorMessage));
      }
    }, (r) {
      emit(VendorRescuePageSuccess());
    });
  }
}
