// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class AuthenticationPages extends StatefulWidget {
//   static const routeName = '/authentication';
//   const AuthenticationPages({Key? key}) : super(key: key);

//   @override
//   _AuthenticationPagesState createState() => _AuthenticationPagesState();
// }

// class _AuthenticationPagesState extends State<AuthenticationPages> {
//   final _formKey = GlobalKey<FormState>();
//   final _emailCpontroller = TextEditingController();
//   final _passwordController = TextEditingController();

//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               TextFormField(
//                 key: GlobalKey(debugLabel: 'emailField'),
//                 autofocus: true,
//                 controller: _emailCpontroller,
//                 decoration: const InputDecoration(
//                   labelText: 'Email',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 16.0),
//               TextFormField(
//                 key: GlobalKey(debugLabel: 'passwordField'),
//                 autofocus: true,
//                 controller: _passwordController,
//                 obscureText: true,
//                 decoration: const InputDecoration(
//                   labelText: 'Password',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 32.0),
//               ElevatedButton(
//                 onPressed: _submit,
//                 child: _isLoading
//                     ? const CircularProgressIndicator()
//                     : const Text('Login'),
//               ),
//               ElevatedButton(
//                 onPressed: _register,
//                 child: _isLoading
//                     ? const CircularProgressIndicator()
//                     : const Text('Register'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
