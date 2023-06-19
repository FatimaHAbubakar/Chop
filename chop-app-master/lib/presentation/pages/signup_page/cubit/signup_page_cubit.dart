import 'package:bloc/bloc.dart';
import 'package:chop/domain/model/user.dart';
import 'package:chop/domain/use_cases/register_use_case.dart';
import 'package:equatable/equatable.dart';

part 'signup_page_state.dart';

class SignupPageCubit extends Cubit<SignupPageState> {
  final RegisterUseCase useCase;

  SignupPageCubit(this.useCase) : super(SignupPageInitial());

  Future<void> signUp(RegisterParams params) async {
    emit(SignupPageLoading());

    final result = await useCase.call(params);

    result.fold((l) => emit(SignupPageError(l.errorMessage)),
        (r) => emit(SignupSuccess(r)));
  }
}
