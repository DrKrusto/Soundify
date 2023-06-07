import 'package:flutter/material.dart';
import 'package:soundify/main.dart';
import 'package:soundify/models/api_response.dart';
import 'package:soundify/models/paging_options.dart';
import 'package:soundify/pages/alert_details.dart';
import 'package:soundify/pages/main_bar.dart';
import 'package:soundify/services/sound_service.dart';
import '../models/paged_sounds.dart';
import '../models/sound.dart';
import 'home_bar.dart';
import 'loading_page.dart';

class SoundsPage extends StatefulWidget {
  const SoundsPage(
      {super.key, required this.search, required this.byUserFavorites});

  final String search;
  final bool byUserFavorites;

  @override
  State<SoundsPage> createState() => _SoundsPageState();
}

class _SoundsPageState extends State<SoundsPage> {
  final List<PagedSounds> _pagedSounds = [];
  List<Sound> _sounds = [];
  int _currentPage = 1;
  int _maxPages = 0;
  bool _isLoading = true;

  Future<void> searchSounds(String search, bool searchForFavorites,
      PagingOptions pagingOptions) async {
    final pagedSounds = await SoundService.fetchSoundsFromPaged(
        _pagedSounds, search, searchForFavorites, pagingOptions);
    if (pagedSounds != null) {
      setState(() {
        _isLoading = false;
        _maxPages = pagedSounds.maxPages;
        _sounds = pagedSounds.sounds;
      });
      return;
    }
    setState(() {
      _sounds = [];
      _maxPages = 0;
      _isLoading = false;
    });
  }

  Future<ApiResponse> interactWithFavorite(Sound sound) async {
    if (widget.byUserFavorites) {
      final response =
          await SoundService.removeFromFavorites(MyApp.user.id, sound.id);
      if (response.apiResponseType == ApiResponseType.success) {
        _sounds.remove(sound);
        setState(() {});
      }
      return response;
    }
    return await SoundService.addToFavorites(MyApp.user.id, sound.id);
  }

  @override
  void initState() {
    searchSounds(widget.search, widget.byUserFavorites,
        PagingOptions(size: MyApp.pagingSize, page: _currentPage));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    for (PagedSounds pagedSound in _pagedSounds) {
      for (Sound sound in pagedSound.sounds) {
        sound.soundPlayer.release();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final String pageName = widget.byUserFavorites
        ? 'Your favorite sounds'
        : widget.search.isNotEmpty
            ? 'Search for \'${widget.search}\' sounds'
            : 'Explore all sounds';
    return Scaffold(
        appBar: MainBar(pageName: pageName),
        bottomNavigationBar: const HomeBar(),
        body: _isLoading
            ? const LoadingPage()
            : _sounds.isNotEmpty
                ? Column(
                    children: [
                      Expanded(
                        child: GridView(
                          padding: const EdgeInsets.all(20.0),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 15.0,
                            mainAxisSpacing: 15.0,
                          ),
                          children: _sounds
                              .map((e) => Draggable<Sound>(
                                  data: e,
                                  onDragCompleted: () => interactWithFavorite(e)
                                      .then((response) => showDialog(
                                          context: context,
                                          builder: (_) => AlertDetails(
                                              message: response.details))),
                                  childWhenDragging: const RawMaterialButton(
                                    onPressed: null,
                                    elevation: 2.0,
                                    fillColor: Colors.grey,
                                    shape: CircleBorder(),
                                  ),
                                  feedback: RawMaterialButton(
                                    onPressed: null,
                                    elevation: 2.0,
                                    fillColor: Colors.redAccent,
                                    shape: const CircleBorder(),
                                    child: Text(e.name),
                                  ),
                                  child: RawMaterialButton(
                                    onPressed: e.playSound,
                                    elevation: 2.0,
                                    fillColor: Colors.redAccent,
                                    shape: const CircleBorder(),
                                    child: Text(e.name),
                                  )))
                              .toList(),
                        ),
                      ),
                      if (_currentPage > -1)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.chevron_left),
                              onPressed: _currentPage > 1
                                  ? () {
                                      setState(() {
                                        _currentPage--;
                                        searchSounds(
                                            widget.search,
                                            widget.byUserFavorites,
                                            PagingOptions(
                                                size: MyApp.pagingSize,
                                                page: _currentPage));
                                      });
                                    }
                                  : null,
                            ),
                            Text("Page $_currentPage"),
                            IconButton(
                              icon: const Icon(Icons.chevron_right),
                              onPressed: _currentPage < _maxPages
                                  ? () {
                                      setState(() {
                                        _currentPage++;
                                        searchSounds(
                                            widget.search,
                                            widget.byUserFavorites,
                                            PagingOptions(
                                                size: MyApp.pagingSize,
                                                page: _currentPage));
                                      });
                                    }
                                  : null,
                            ),
                          ],
                        )
                    ],
                  )
                : const Center(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.grey,
                        size: 65.0,
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        'No sounds were found...',
                        style: TextStyle(fontSize: 17.5, color: Colors.grey),
                      )
                    ],
                  )));
  }
}
