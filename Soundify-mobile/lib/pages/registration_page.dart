import 'package:flutter/material.dart';
import 'package:soundify/services/user_service.dart';

import 'alert_details.dart';
import 'loading_page.dart';
import 'main_bar.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  Future<String> register(
      String email, String username, String password) async {
    setState(() {
      _isLoading = true;
    });
    final response = await UserService.createUser(email, username, password);
    setState(() {
      _isLoading = false;
    });
    return response.details;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainBar(pageName: "Create an account"),
      body: _isLoading
          ? const LoadingPage()
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 24.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          String username = _usernameController.text;
                          String email = _emailController.text;
                          String password = _passwordController.text;
                          register(email, username, password).then((value) =>
                              showDialog(
                                  context: context,
                                  builder: (_) =>
                                      AlertDetails(message: value)));
                        },
                        child: const Text('Register'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/auth');
                        },
                        child: const Text('Go back'),
                      ),
                    ],
                  )
                ],
              ),
            ),
    );
  }
}
