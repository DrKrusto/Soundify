import 'package:flutter/material.dart';
import 'package:soundify/main.dart';
import 'package:soundify/models/api_response.dart';
import 'package:soundify/pages/alert_details.dart';
import 'package:soundify/pages/main_bar.dart';
import 'package:soundify/services/user_service.dart';

import '../models/user.dart';
import 'home_bar.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key, required this.user});

  final User user;

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  Future<ApiResponse?> uploadImage() async {
    final image = await UserService.searchForImageOnDevice();
    if (image == null) {
      return null;
    }
    return await UserService.uploadProfilePicture(widget.user.id, image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const MainBar(pageName: 'Your page'),
        bottomNavigationBar: const HomeBar(),
        body: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Center(
              child: Column(children: [
                ClipOval(
                    child: GestureDetector(
                  onTap: () {
                    uploadImage().then((response) => {
                          if (response != null)
                            {
                              showDialog(
                                  context: context,
                                  builder: (_) =>
                                      AlertDetails(message: response.details))
                            }
                        });
                  },
                  child: Image.network(
                    widget.user.pictureUrl,
                    fit: BoxFit.cover,
                    width: 150,
                    height: 150,
                  ),
                )),
                const SizedBox(height: 10.0),
                Text(
                  '@${widget.user.username}',
                  style: const TextStyle(fontSize: 40.0),
                ),
                const SizedBox(height: 10.0),
                ElevatedButton(
                    onPressed: () {
                      MyApp.user = User.empty();
                      Navigator.pushReplacementNamed(context, '/auth');
                    },
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [Icon(Icons.person_off), Text(" Disconnect")],
                    ))
              ]),
            )));
  }
}
