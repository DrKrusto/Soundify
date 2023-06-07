import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:soundify/main.dart';
import 'package:soundify/pages/alert_details.dart';
import 'package:soundify/services/sound_service.dart';

import '../models/sound.dart';

class HomeBar extends StatefulWidget {
  const HomeBar({Key? key}) : super(key: key);

  @override
  State<HomeBar> createState() => _HomeBarState();
}

class _HomeBarState extends State<HomeBar> {
  double _addBubbleRadius = 30.0;

  bool isCurrentRoute(String route, BuildContext context) {
    final String currentRoute = ModalRoute.of(context)?.settings.name ?? '';
    return currentRoute == route;
  }

  void changeBubbleRadius(double size) {
    setState(() {
      _addBubbleRadius = size;
    });
  }

  void redirectTo(String route, BuildContext context) {
    if (!isCurrentRoute(route, context)) {
      Navigator.pushReplacementNamed(context, route);
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 75,
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            color: Color.fromARGB(255, 201, 201, 201),
            offset: Offset(0, 15),
            spreadRadius: 10.0,
          )
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Stack(
        children: [
          const Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Material(
                color: Colors.red,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 70,
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(
                  Icons.home_rounded,
                  color: Colors.white,
                  size: isCurrentRoute('/main', context) ? 35 : 24,
                ),
                onPressed: () => redirectTo('/main', context),
              ),
              IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                  size: isCurrentRoute('/search', context) ? 35 : 24,
                ),
                onPressed: () => redirectTo('/search', context),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  DragTarget<Sound>(
                      onMove: (details) => changeBubbleRadius(35.0),
                      onLeave: (data) => changeBubbleRadius(30.0),
                      onAccept: (data) => changeBubbleRadius(30.0),
                      builder: (
                        BuildContext context,
                        List<dynamic> accepted,
                        List<dynamic> rejected,
                      ) =>
                          CircleAvatar(
                            radius: _addBubbleRadius,
                            child: IconButton(
                              icon: const Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              onPressed: () async {
                                final XFile? file =
                                    await SoundService.searchForSoundOnDevice();
                                if (file == null) return;
                                await SoundService.uploadSound(
                                        MyApp.user.id, file)
                                    .then((response) => showDialog(
                                        context: context,
                                        builder: (_) => AlertDetails(
                                            message: response.details)));
                              },
                            ),
                          )),
                ],
              ),
              IconButton(
                icon: Icon(
                  Icons.favorite_rounded,
                  color: Colors.white,
                  size: isCurrentRoute('/favorites', context) ? 35 : 24,
                ),
                onPressed: () => redirectTo('/favorites', context),
              ),
              IconButton(
                icon: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: isCurrentRoute('/user', context) ? 35 : 24,
                ),
                onPressed: () => redirectTo('/user', context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
