import 'package:authentication/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPage extends StatefulWidget {
  static const routeName = '/register';
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final List<FormFieldItem> formFieldItems = [
    FormFieldItem(
      key: 'username',
      label: 'Username',
      controller: TextEditingController(),
    ),
    FormFieldItem(
      key: 'firstName',
      label: 'First Name',
      controller: TextEditingController(),
    ),
    FormFieldItem(
      key: 'lastName',
      label: 'Last Name',
      controller: TextEditingController(),
    ),
    FormFieldItem(
      key: 'age',
      label: 'Age',
      controller: TextEditingController(),
    ),
    FormFieldItem(
      key: 'email',
      label: 'Email',
      controller: TextEditingController(),
    ),
    FormFieldItem(
      key: 'password',
      label: 'Password',
      controller: TextEditingController(),
    ),
  ];

  void _onSubmit() {
    final email =
        formFieldItems.firstWhere((e) => e.key == 'email').controller.text;
    final password =
        formFieldItems.firstWhere((e) => e.key == 'password').controller.text;
    final username =
        formFieldItems.firstWhere((e) => e.key == 'username').controller.text;
    final firstName =
        formFieldItems.firstWhere((e) => e.key == 'firstName').controller.text;
    final lastName =
        formFieldItems.firstWhere((e) => e.key == 'lastName').controller.text;
    final age =
        formFieldItems.firstWhere((e) => e.key == 'age').controller.text;

    context.read<AuthBloc>().add(
          RegisterRequested(
              email: email,
              password: password,
              username: username,
              firstName: firstName,
              lastName: lastName,
              age: int.tryParse(age) ?? int.parse(age)),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            // optional loading UI
            CircularProgressIndicator();
          }

          if (state is Authenticated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Register success')),
            );
            // Navigator.pushReplacementNamed(context, '/home');
          }

          if (state is Unauthenticated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: ListView.builder(
          itemCount: formFieldItems.length + 1,
          itemBuilder: (context, index) {
            if (index == formFieldItems.length) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: _onSubmit,
                  child: const Text('Submit'),
                ),
              );
            }

            final field = formFieldItems[index];

            return Padding(
              padding: const EdgeInsets.all(8),
              child: buildTextField(
                fieldKey: field.key,
                label: field.label,
                controller: field.controller,
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (final field in formFieldItems) {
      field.controller.dispose();
    }
    super.dispose();
  }
}

Widget buildTextField({
  required String fieldKey,
  required String label,
  required TextEditingController controller,
}) {
  return TextField(
    key: ValueKey(fieldKey),
    controller: controller,
    obscureText: fieldKey == 'password',
    decoration: InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
    ),
  );
}

class FormFieldItem {
  final String key;
  final String label;
  final TextEditingController controller;

  FormFieldItem({
    required this.key,
    required this.label,
    required this.controller,
  });
}
