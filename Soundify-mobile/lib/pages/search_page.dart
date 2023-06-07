import 'package:flutter/material.dart';
import 'package:soundify/pages/home_bar.dart';
import 'package:soundify/pages/main_bar.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const MainBar(
          pageName: 'Search',
        ),
        bottomNavigationBar: const HomeBar(),
        body: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    labelText: 'Search for sounds',
                  ),
                ),
                const SizedBox(height: 24.0),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/sounds',
                          arguments: _searchController.text.isNotEmpty
                              ? _searchController.text
                              : null);
                    },
                    child: const Text('Search'))
              ]),
        ));
  }
}
