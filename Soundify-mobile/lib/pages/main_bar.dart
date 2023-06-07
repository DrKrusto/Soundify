import 'package:flutter/material.dart';

import '../main.dart';

class MainBar extends StatelessWidget implements PreferredSizeWidget {
  const MainBar({super.key, required this.pageName});

  final String pageName;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Icon(Icons.library_music), Text(MyApp.title)],
            ),
            Text(
              pageName,
              style: const TextStyle(fontSize: 10.0),
            )
          ]),
    );
  }
}
