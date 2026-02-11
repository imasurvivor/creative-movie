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
}
