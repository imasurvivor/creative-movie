import 'package:core/common/failure.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either<Failure, String>> login(String email, String password);
  Future<Either<Failure, String>> registerAndSaveUser({
    required String email,
    required String password,
    required String username,
    required int age,
    String firstName,
    String lastName,
  });
  Future<Either<Failure, bool>> isLoggedIn();
  Future<Either<Failure, void>> sendPasswordResetEmail(String email);
  Future<Either<Failure, void>> updatePassword(String newPassword);
  Future<Either<Failure, void>> deleteUser();
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, String?>> getUserId();
}
