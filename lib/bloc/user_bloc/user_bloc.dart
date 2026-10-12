import 'package:bloc/bloc.dart';
import 'package:discipline/servises/dio/dio_users.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final DioUsers dioUsers;

  UserBloc(this.dioUsers) : super(UserInitial()) {
    on<LoadUser>(_loadUser);
    on<UpdateUser>(_updateUser);
  }

  Future<void> _loadUser(
      LoadUser event,
      Emitter<UserState> emit,
      ) async {
    emit(UserLoading());

    try {
      final user = await dioUsers.getUser();

      emit(UserLoaded(user));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _updateUser(
      UpdateUser event,
      Emitter<UserState> emit,
      ) async {
    // Здесь позже будет логика обновления пользователя.
  }
}