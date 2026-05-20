import 'package:authentication/presentation/bloc/auth_bloc.dart';
import 'package:authentication/presentation/pages/signup_pages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ditonton/home_page.dart';

class AuthenticationPage extends StatefulWidget {
  static const routeName = '/authentication-page';
  AuthenticationPage({Key? key}) : super(key: key);

  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void _onSubmit() {
    context.read<AuthBloc>().add(LoginRequested(
          email: emailController.text,
          password: passwordController.text,
        ));
  }

  bool _isHidden = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            // optional loading UI
            // you can also show a loading dialog or indicator here
            CircularProgressIndicator();
          }
          if (state is Authenticated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Success Login!')),
            );
            Navigator.pushReplacementNamed(context, HomePage.routeName);
          }
          if (state is Unauthenticated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Semantics(
                identifier: 'email_input',
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'email',
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Semantics(
                identifier: 'password_input',
                child: TextField(
                  controller: passwordController,
                  obscureText: _isHidden
                      ? true
                      : false, // this will hide the text if _isHidden is true
                  decoration: InputDecoration(
                      labelText: 'password',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(_isHidden
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _isHidden = !_isHidden;
                          });
                        },
                      )),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Semantics(
                identifier: 'login_btn',
                child: ElevatedButton(
                  onPressed: _onSubmit,
                  child: const Text('Login'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, RegisterPage.routeName);
                },
                child: const Text('Don\'t have an account? Register here'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
}
