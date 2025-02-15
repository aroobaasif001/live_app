import 'package:audioplayers/audioplayers.dart';

class AudioPlayerService {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> playSound(String assetPath) async {
    try {
      await _audioPlayer.stop(); // Stop any previous audio
      await _audioPlayer.play(AssetSource(assetPath)); // Play sound from assets
print('playinggg');
      _audioPlayer.onPlayerComplete.listen((event) {
        _audioPlayer.dispose(); // Dispose when finished
      });
    } catch (e) {
      print("Error playing sound: $e");
    }
  }
}
