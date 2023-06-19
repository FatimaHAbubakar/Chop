import 'package:bloc/bloc.dart';
import 'package:chop/domain/model/user.dart';
import 'package:chop/domain/use_cases/login_use_case.dart';
import 'package:equatable/equatable.dart';

part 'login_page_state.dart';

class LoginPageCubit extends Cubit<LoginPageState> {
  final LoginUseCase useCase;

  LoginPageCubit(this.useCase) : super(LoginPageInitial());

  Future<void> login(LoginParams params) async {
    emit(LoginPageLoading());

    final result = await useCase.call(params);

    result.fold((l) => emit(LoginPageError(l.errorMessage)),
        (r) => emit(LoginSuccess(r)));
  }
}
