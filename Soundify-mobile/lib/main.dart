import 'package:flutter/material.dart';
import 'package:soundify/pages/search_page.dart';
import 'package:soundify/pages/sounds_page.dart';
import 'package:soundify/pages/authentification_page.dart';
import 'package:soundify/pages/registration_page.dart';
import 'package:soundify/pages/user_page.dart';

import 'models/user.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String serverUrl = 'http://192.168.1.29';
  static const String title = 'Soundify';
  static int pagingSize = 2;
  static User user = User.empty();
  static String? jwtToken;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Soundify',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      initialRoute: user.id.isNotEmpty ? '/main' : '/auth',
      routes: {
        '/auth': (context) => const AuthenticationPage(),
        '/sounds': (context) {
          final search = ModalRoute.of(context)?.settings.arguments as String?;
          return SoundsPage(
            search: search ?? '',
            byUserFavorites: false,
          );
        },
        '/user': (context) => UserPage(
              user: ModalRoute.of(context)?.settings.arguments as User? ??
                  MyApp.user,
            ),
        '/registration': (context) => const RegistrationPage(),
        '/search': (context) => const SearchPage(),
        '/favorites': (context) {
          return SoundsPage(search: MyApp.user.id, byUserFavorites: true);
        },
        '/main': (context) => const SoundsPage(
              search: '',
              byUserFavorites: false,
            )
      },
    );
  }
}
