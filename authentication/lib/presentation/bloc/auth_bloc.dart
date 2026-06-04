import 'package:authentication/domain/usecases/auth.dart';
import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final SignUpUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;
  final IsLoggedInUseCase isLoggedInUseCase;
  final GetCurrentUserIdUseCase getCurrentUserIdUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
    required this.isLoggedInUseCase,
    required this.getCurrentUserIdUseCase,
  }) : super(AuthInitial()) {
    on<RegisterRequested>((event, emit) async {
      emit(AuthLoading());

      final result = await registerUseCase.execute(event.email, event.password,
          event.username, event.firstName, event.lastName, event.age);
      result.fold((failure) {
        emit(Unauthenticated(failure.message));
      }, (userId) {
        emit(Authenticated(userId));
      });
    });

    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      final result = await loginUseCase.execute(event.email, event.password);
      result.fold((failure) {
        print('Login Failure: ${failure.message}');
        emit(Unauthenticated(failure.message));
      }, (userId) {
        print('Login Success: $userId');
        emit(Authenticated(userId));
      });
    });
  }
}
