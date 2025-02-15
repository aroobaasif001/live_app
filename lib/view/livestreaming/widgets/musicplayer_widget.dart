import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class MusicPlayerWidget extends StatelessWidget {
  final AudioPlayer audioPlayer;
  final String? currentMusicPath;
  final Duration currentPosition;
  final Duration totalDuration;
  final VoidCallback stopMusic;
  final ValueChanged<double> seekMusic;

  MusicPlayerWidget({
    required this.audioPlayer,
    required this.currentMusicPath,
    required this.currentPosition,
    required this.totalDuration,
    required this.stopMusic,
    required this.seekMusic,
  });

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes);
    final seconds = twoDigits(duration.inSeconds % 60);
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: Draggable(
        feedback: _buildMusicCard(context),
        child: _buildMusicCard(context),
        childWhenDragging: SizedBox(),
      ),
    );
  }

  Widget _buildMusicCard(BuildContext context) {
    return Card(
      color: Colors.black.withOpacity(0.8),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (currentMusicPath != null)
              Text(
                "Now Playing: ${currentMusicPath?.split('/').last}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            if (currentMusicPath != null)
              Slider(
                inactiveColor: Colors.grey,
                activeColor: Colors.white,
                value: currentPosition.inSeconds.toDouble(),
                max: totalDuration.inSeconds.toDouble(),
                onChanged: seekMusic,
              ),
            if (currentMusicPath != null)
              Text(
                '${_formatDuration(currentPosition)} / ${_formatDuration(totalDuration)}',
                style: TextStyle(color: Colors.grey),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.stop, color: Colors.white),
                  onPressed: stopMusic,
                ),
                IconButton(
                  icon: Icon(
                    audioPlayer.state == PlayerState.playing
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    if (audioPlayer.state == PlayerState.playing) {
                      await audioPlayer.pause();
                    } else {
                      if (currentMusicPath != null) {
                        await audioPlayer.play(DeviceFileSource(currentMusicPath!));
                      } else {
                        print('No music file selected!');
                      }
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
