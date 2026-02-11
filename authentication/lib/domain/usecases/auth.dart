import 'package:core/core.dart';
import 'package:dartz/dartz.dart';

class LoginUseCase {
  final AuthRepository repository;
  LoginUseCase(this.repository);

  Future<Either<Failure, String>> execute(String email, String password) {
    return repository.login(email, password);
  }
}

class SignUpUseCase {
  final AuthRepository repository;
  SignUpUseCase(this.repository);

  Future<Either<Failure, String>> execute(String email, String password) {
    return repository.registerAndSaveUser(
        email: email, password: password, username: '', age: 0);
  }
}

class DeleteUserUseCase {
  final AuthRepository repository;
  DeleteUserUseCase(this.repository);

  Future<Either<Failure, void>> execute() {
    return repository.deleteUser();
  }
}

class LogoutUseCase {
  final AuthRepository repository;
  LogoutUseCase(this.repository);

  Future<Either<Failure, void>> execute() {
    return repository.signOut();
  }
}

class IsLoggedInUseCase {
  final AuthRepository repository;
  IsLoggedInUseCase(this.repository);

  Future<Either<Failure, bool>> execute() {
    return repository.isLoggedIn();
  }
}

class GetCurrentUserIdUseCase {
  final AuthRepository repository;
  GetCurrentUserIdUseCase(this.repository);

  Future<Either<Failure, String?>> execute() {
    return repository.getUserId();
  }
}
