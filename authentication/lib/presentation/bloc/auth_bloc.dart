// import 'package:bloc/bloc.dart';
// import 'package:core/core.dart';
// import 'package:equatable/equatable.dart';

// part 'auth_event.dart';
// part 'auth_state.dart';

// class AuthBloc extends Bloc<AuthEvent, AuthState> {
//   final AuthRepository authRepository;
//   AuthBloc(this.authRepository) : super(AuthInitial()) {
//     on<AuthEvent>((event, emit) async {
//       if (event is AppStarted) {
//         emit(AuthLoading());
//         try {
//           final isSignedIn = await authRepository.isLoggedIn();
//           if (isSignedIn) {
//             final userId = await authRepository.getCurrentUserId();
//             emit(Authenticated(userId));
//           } else {
//             emit(Unauthenticated('User not signed in'));
//           }
//         } catch (e) {
//           emit(AuthError(e.toString()));
//         }
//       } else if (event is RegisterRequested) {
//         // Handle registration event if needed

//         try {
//           final userId = await authRepository.;
//           emit(RegistrationSuccess());
//         } catch (e) {
//           emit(RegistrationFailure(e.toString()));
//         }
//       } else if (event is LoggedIn) {
//         emit(Authenticated(event.userId));
//       } else if (event is LoggedOut) {
//         emit(AuthLoading());
//         try {
//           await authRepository.logout();
//           emit(Unauthenticated('User signed out'));
//         } catch (e) {
//           emit(AuthError(e.toString()));
//         }
//       }
//     });
//   }
// }

// class AuthBlocRegister extends Bloc<AuthEvent, AuthState> {
//   final AuthRepository authRepository;
//   AuthBlocRegister(this.authRepository) : super(AuthInitial()) {
//     on<AuthEvent>((event, emit) async {
//       // Additional event handling for registration can be added here
//     });
//   }
// }
