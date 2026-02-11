import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  static const routeName = '/register';
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final List<Map<String, String>> formFields = [
    {
      'label': 'Username',
      'key': 'username',
    },
    {'label': 'First Name', 'key': 'firstName'},
    {'label': 'Last Name', 'key': 'lastName'},
    {'label': 'Age', 'key': 'age'},
    {'label': 'Email', 'key': 'email'},
    {'label': 'Password', 'key': 'password'},
  ];

  final List<FormFieldItem> formFieldItems = [
    FormFieldItem(
        key: 'username',
        label: 'Username',
        controller: TextEditingController()),
    FormFieldItem(
        key: 'firstName',
        label: 'First Name',
        controller: TextEditingController()),
    FormFieldItem(
        key: 'lastName',
        label: 'Last Name',
        controller: TextEditingController()),
    FormFieldItem(
        key: 'age', label: 'Age', controller: TextEditingController()),
    FormFieldItem(
        key: 'email', label: 'Email', controller: TextEditingController()),
    FormFieldItem(
        key: 'password',
        label: 'Password',
        controller: TextEditingController()),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (final field in formFieldItems) {
      field.controller.text = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: ListView.builder(
          itemCount: formFieldItems.length + 1,
          itemBuilder: (context, index) {
            if (index == formFieldItems.length) {
              // ✅ SUBMIT BUTTON
              return Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Submit'),
                ),
              );
            }
            final field = formFieldItems[index];

            return Padding(
                padding: const EdgeInsets.all(8.0),
                child: buildTextField(
                    field: {'key': field.key, 'label': field.label},
                    controller: field.controller));
          }),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    for (final field in formFieldItems) {
      field.controller.dispose();
    }
    super.dispose();
  }
}

Widget buildTextField(
    {required Map<String, String> field,
    required TextEditingController controller}) {
  final key = field['key'];
  final label = field['label'];
  return TextField(
    key: ValueKey(key),
    controller: controller,
    obscureText: key == 'password' ? true : false,
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

  FormFieldItem(
      {required this.key, required this.label, required this.controller});
}
