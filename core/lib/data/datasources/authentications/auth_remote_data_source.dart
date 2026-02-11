// ignore: depend_on_referenced_packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<String> login(String email, String password) {
    try {
      final userCredential = _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential.then((value) => value.user?.uid ?? '');
    } on FirebaseAuthException catch (e) {
      return Future.error(e.message ?? 'An unknown error occurred');
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
      return Future.error(e.message ?? 'An unknown error occurred');
    }
  }
}
