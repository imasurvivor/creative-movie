// // import 'package:equatable/equatable.dart';
// part of 'auth_bloc.dart';

// abstract class AuthState extends Equatable {
//   const AuthState();

//   @override
//   List<Object> get props => [];
// }

// class AuthInitial extends AuthState {}

// class AuthLoading extends AuthState {}

// class Authenticated extends AuthState {
//   final String userId;

//   const Authenticated(this.userId);

//   @override
//   List<Object> get props => [userId];
// }

// class Unauthenticated extends AuthState {
//   final String message;

//   const Unauthenticated(this.message);

//   @override
//   List<Object> get props => [message];
// }

// class AuthError extends AuthState {
//   final String error;

//   const AuthError(this.error);

//   @override
//   List<Object> get props => [error];
// }

// class RegistrationSuccess extends AuthState {
//   final String userId;

//   const RegistrationSuccess(this.userId);

//   @override
//   List<Object> get props => [userId];
// }

// class RegistrationFailure extends AuthState {
//   final String error;

//   const RegistrationFailure(this.error);

//   @override
//   List<Object> get props => [error];
// }
