import 'package:audioplayers/audioplayers.dart';

class Sound {
  Sound(
      {required this.id,
      required this.name,
      required this.fileUrl,
      required this.uploadedBy,
      required this.soundPlayer});

  String id;
  String name;
  String fileUrl;
  String uploadedBy;
  AudioPlayer soundPlayer;

  void playSound() async {
    await soundPlayer.stop();
    await soundPlayer.resume();
  }

  factory Sound.fromJson(Map<String, dynamic> json) {
    final String id = json['id'];
    final String fileUrl = json['fileUrl'];
    final AudioPlayer audioPlayer = AudioPlayer();
    audioPlayer.setSourceUrl(fileUrl);
    audioPlayer.setPlayerMode(PlayerMode.lowLatency);
    audioPlayer.setReleaseMode(ReleaseMode.stop);
    return Sound(
        id: id,
        name: json['name'],
        fileUrl: fileUrl,
        uploadedBy: json['uploader']['id'],
        soundPlayer: audioPlayer);
  }
}
