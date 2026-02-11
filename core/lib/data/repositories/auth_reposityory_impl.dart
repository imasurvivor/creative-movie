import 'dart:io';

import 'package:core/core.dart';
import 'package:dartz/dartz.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, String>> login(String email, String password) async {
    try {
      final result = remoteDataSource.login(email, password);
      return Right(result.toString());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, String>> registerAndSaveUser({
    required String email,
    required String password,
    required String username,
    required int age,
    String firstName = '',
    String lastName = '',
  }) async {
    try {
      final result = await remoteDataSource.registerAndSaveUser(
        email: email,
        password: password,
        username: username,
        age: age,
        firstName: firstName,
        lastName: lastName,
      );
      return Right(result);
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<Failure, void>> deleteUser()async {
    try {
      return remoteDataSource.deleteUser().then((value) => Right(value));
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, String?>> getUserId() async{
    try {
      final result = await remoteDataSource.getUserId();
      return Right(result);
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() async{
    try{
      final result = await remoteDataSource.isLoggedIn();
      return Right(result);
    }on ServerException{
      return Left(ServerFailure(''));
    }on SocketException{
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, void>> sendPasswordResetEmail(String email) async{
    try{
      return remoteDataSource.sendPasswordResetEmail(email).then((value) => Right(value));
    }on ServerException{
      return Left(ServerFailure(''));
    }on SocketException{
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, void>> signOut()async {
    try{
      return remoteDataSource.signOut().then((value) =>   Right(value));
    } on ServerException {
      return Left(ServerFailure(''));
    }
    on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
  }}

  @override
  Future<Either<Failure, void>> updatePassword(String newPassword) async{
    try {
      return remoteDataSource.updatePassword(newPassword).then((value) => Right(value));
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }
}
