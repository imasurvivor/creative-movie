import 'package:authentication/presentation/bloc/auth_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            CircularProgressIndicator();
          }
          if (state is Authenticated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Success Login!')),
            );
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
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'password',
                    border: const OutlineInputBorder(),
                  ),
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
              )
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
