import 'package:flutter/material.dart';
import 'package:soundify/main.dart';
import 'package:soundify/models/api_response.dart';
import 'package:soundify/pages/alert_details.dart';
import 'package:soundify/pages/loading_page.dart';
import 'package:soundify/services/user_service.dart';

import '../models/user.dart';
import 'main_bar.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _isConnected = false;

  Future<String> tryToLogin(String email, String password) async {
    setState(() {
      _isLoading = true;
    });
    final loginResponse = await UserService.loginUser(email, password);
    if (loginResponse.apiResponseType != ApiResponseType.success) {
      setState(() {
        _isLoading = false;
      });
      return loginResponse.details;
    }
    final jwtToken = loginResponse.value;
    MyApp.jwtToken = jwtToken;
    final getUserResponse = await UserService.getUserFromApi(email: email);
    if (getUserResponse.apiResponseType != ApiResponseType.success) {
      setState(() {
        _isLoading = false;
      });
      return loginResponse.details;
    }
    MyApp.user = getUserResponse.value ?? User.empty();
    _isConnected = true;
    return 'Connected';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainBar(pageName: "Authentication"),
      body: _isLoading
          ? const LoadingPage()
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    ),
                  ),
                  const SizedBox(height: 12.0),
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
                            tryToLogin(_emailController.text,
                                    _passwordController.text)
                                .then((value) => {
                                      if (_isConnected)
                                        {
                                          Navigator.pushReplacementNamed(
                                              context, '/main')
                                        }
                                      else
                                        {
                                          showDialog(
                                              context: context,
                                              builder: (_) =>
                                                  AlertDetails(message: value))
                                        }
                                    });
                          },
                          child: const Text('Sign in')),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, '/registration');
                          },
                          child: const Text('Register'))
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
