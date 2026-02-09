import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      // Handle authentication errors here
      print('Error: $e');
      return null;
    }
  }

  Future<User?> createUserWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      print('Error: $e');
      return null;
    }
  }
}

class AuthenticationPages extends StatefulWidget {
  static const routeName = '/authentication';
  const AuthenticationPages({Key? key}) : super(key: key);

  @override
  _AuthenticationPagesState createState() => _AuthenticationPagesState();
}

class _AuthenticationPagesState extends State<AuthenticationPages> {
  final _formKey = GlobalKey<FormState>();
  final _emailCpontroller = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool isLoading = false;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // Perform authentication logic here
      final email = _emailCpontroller.text;
      final password = _passwordController.text;
      // Example: Call your authentication service with email and password
      setState(() => isLoading = true);
      _authService.signInWithEmailAndPassword(email, password).then((value) => {
            setState(() => isLoading = false),
            if (value != null)
              {
                // Navigate to the next page on successful login
                Navigator.pushReplacementNamed(context, '/home')
              }
            else
              {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Login failed')),
                )
              }
          });
    }
  }

  bool _isLoading = false;
  void _register() async {
    setState(() {
      _isLoading = true;
    });
    // Registration logic here
    try {
      final user = await _authService.createUserWithEmailAndPassword(
          email: _emailCpontroller.text, password: _passwordController.text);
      if (user != null && mounted) {
        // Registration successful, navigate to home or show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful')),
        );
      }
    } catch (e) {
      // Handle registration error
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration failed: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  final FocusNode _emailFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                key: GlobalKey(debugLabel: 'emailField'),
                focusNode: _emailFocusNode,
                autofocus: true,
                controller: _emailCpontroller,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                key: GlobalKey(debugLabel: 'passwordField'),
                autofocus: true,
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: _register,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
