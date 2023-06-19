part of 'profile_pages_cubit.dart';

abstract class ProfilePagesState extends Equatable {
  const ProfilePagesState();

  @override
  List<Object> get props => [];
}

class ProfilePagesInitial extends ProfilePagesState {}

class ProfilePageLoading extends ProfilePagesState {}

class ProfilePagesLogOut extends ProfilePagesState {}
