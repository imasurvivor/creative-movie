import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core/common/exception.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      throw ServerException();
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
      throw Exception(e.message ?? 'An unknown error occurred');
    }
  }

  @override
  Future<void> deleteUser() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      await user.delete();
    } else {
      throw Exception('No user is currently signed in.');
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
      throw Exception('No user is currently signed in.');
    }
  }
}
