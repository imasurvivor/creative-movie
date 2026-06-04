import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core/common/exception.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

abstract class AuthRemoteDataSource {
  Future<String> login(String email, String password);
  Future<String> registerAndSaveUser({
    required String email,
    required String password,
    required String username,
    required int age,
    String firstName,
    String lastName,
  });
  Future<User?> getCurrentUser();

  Future<bool> isLoggedIn();

  Future<void> sendPasswordResetEmail(String email);

  Future<void> updatePassword(String newPassword);

  Future<void> deleteUser();
  Future<void> signOut();

  Future<String?> getUserId();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<String> login(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      print('logged as ${userCredential.user!.email}');
      return userCredential.user!.uid;
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Login Failed';
      print('Firebase Error Code: ${e.code}');
      print('Firebase Error Message: ${e.message}');
      if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        errorMessage = 'The password is incorrect. Please try again.';
      } else if (e.code == 'user-not-found') {
        errorMessage = 'No user found with this email address.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email address is not valid.';
      } else if (e.code == 'user-disabled') {
        errorMessage = 'This user account has been disabled.';
      } else if (e.code == 'too-many-requests') {
        errorMessage = 'Too many login attempts. Please try again later.';
      }
      print('Error Message Being Thrown: $errorMessage');
      throw ServerException(errorMessage);
    }
  }

  @override
  Future<String> registerAndSaveUser({
    required String email,
    required String password,
    required String username,
    required int age,
    String firstName = '',
    String lastName = '',
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      final uid = userCredential.user?.uid;

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'username': username,
        'age': age,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'createdAt': DateTime.now(),
      });

      return uid ?? '';
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Registration Failed';
      if (e.code == 'email-already-in-use') {
        errorMessage = 'This email address is already registered.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email address is not valid.';
      } else if (e.code == 'operation-not-allowed') {
        errorMessage = 'Email/password registration is not enabled.';
      } else if (e.code == 'weak-password') {
        errorMessage = 'The password is too weak. Use a stronger password.';
      }
      throw ServerException(errorMessage);

      //throw ServerException();
    }
  }

  @override
  Future<void> deleteUser() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      await user.delete();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<User?> getCurrentUser() {
    final user = _firebaseAuth.currentUser;
    return user != null ? Future.value(user) : Future.value(null);
  }

  @override
  Future<String?> getUserId() {
    final user = _firebaseAuth.currentUser;
    return Future.value(user?.uid);
  }

  @override
  Future<bool> isLoggedIn() {
    final user = _firebaseAuth.currentUser;
    return Future.value(user != null);
  }

  @override
  Future<void> sendPasswordResetEmail(String email) {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<void> updatePassword(String newPassword) {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      return user.updatePassword(newPassword);
    } else {
      throw ServerException();
    }
  }
}
