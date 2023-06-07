import 'package:soundify/models/sound.dart';

class PagedSounds {
  List<Sound> sounds;
  int maxPages;
  int currentPage;

  PagedSounds(
      {required this.sounds,
      required this.maxPages,
      required this.currentPage});

  factory PagedSounds.fromJson(Map<String, dynamic> json) {
    List<Sound> sounds = <Sound>[];

    var soundsList = json['sounds'] as List<dynamic>;
    sounds = soundsList.map((soundJson) => Sound.fromJson(soundJson)).toList();

    return PagedSounds(
        sounds: sounds,
        maxPages: json['maxPages'] ?? 0,
        currentPage: json['currentPage'] ?? 0);
  }
}
