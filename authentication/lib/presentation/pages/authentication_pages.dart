import 'package:authentication/presentation/bloc/auth_bloc.dart';
import 'package:authentication/presentation/pages/signup_pages.dart';
import 'package:core/common/constants.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
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
  bool _isLoadingDialogShown = false;
  final _formKey = GlobalKey<FormState>();

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(LoginRequested(
            email: emailController.text,
            password: passwordController.text,
          ));
    }
  }

  bool _isHidden = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Login'),
      // ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            if (!_isLoadingDialogShown) {
              _isLoadingDialogShown = true;
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const AlertDialog(
                  content: Row(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(width: 20),
                      Text('Loading...'),
                    ],
                  ),
                ),
              );
            }
          }
          if (state is Authenticated) {
            _isLoadingDialogShown = false;
            // Close loading dialog if present
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Success Login!')),
            );
            Navigator.pushReplacementNamed(context, HomePage.routeName);
          }
          if (state is Unauthenticated) {
            _isLoadingDialogShown = false;
            // Close loading dialog if present
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Something went wrong', style: kSubtitle),
                content: Text(state.message, style: kBodyText),
                icon: Icon(Icons.warning, color: kColorScheme.error),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          }
        },
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          'Login',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      Semantics(
                        identifier: 'email_input',
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!value.contains('@')) return 'Invalid email';

                            return null;
                          },
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
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
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
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: InkWell(
                              onTap: _onSubmit,
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                width: 200,
                                height: 50,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: kColorScheme.primary,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Login',
                                  style:
                                      TextStyle(color: kColorScheme.onPrimary),
                                ),
                              ),
                            ),
                          )),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, RegisterPage.routeName);
                        },
                        child:
                            const Text('Don\'t have an account? Register here'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
