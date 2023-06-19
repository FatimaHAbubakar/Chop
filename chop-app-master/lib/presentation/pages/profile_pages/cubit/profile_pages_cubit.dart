import 'package:bloc/bloc.dart';
import 'package:chop/core/use_case/use_case.dart';
import 'package:chop/domain/use_cases/log_out_use_case.dart';
import 'package:equatable/equatable.dart';

part 'profile_pages_state.dart';

class ProfilePagesCubit extends Cubit<ProfilePagesState> {
  final LogOutUseCase useCase;

  ProfilePagesCubit(this.useCase) : super(ProfilePagesInitial());

  Future<void> logOut() async {
    await useCase.call(NoParams());
    emit(ProfilePagesLogOut());
  }
}
