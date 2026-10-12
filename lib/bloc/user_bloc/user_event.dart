part of 'user_bloc.dart';

abstract class UserEvent {}

class LoadUser extends UserEvent {}

class UpdateUser extends UserEvent {}