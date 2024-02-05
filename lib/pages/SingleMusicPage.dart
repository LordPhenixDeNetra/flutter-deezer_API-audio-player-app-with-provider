// ignore_for_file: file_names

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:my_n_music/models/Music.dart';
import 'package:my_n_music/services/AudioProvider.dart';
import 'package:my_n_music/utils/Utils.dart';
import 'package:provider/provider.dart';

class SingleMusicPage extends StatelessWidget {
  AudioPlayer audioPlayer = AudioPlayer();

  final bool isPlaying;

  Duration duration = Duration.zero;

  Duration position = Duration.zero;

  final Music singleMusic;

  SingleMusicPage(
      {super.key, required this.singleMusic, required this.isPlaying});

  @override
  Widget build(BuildContext context) {
    final audioProvider = Provider.of<AudioProvider>(context);
    int cuurentPlayedItem = 1;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 224, 249, 255),
      appBar: AppBar(
        title: Text("Music"),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 145, 233, 255),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 140,
              // backgroundImage: AssetImage("images/disque_2.png"),
              backgroundImage: NetworkImage(singleMusic.artistPicture!),
            ),
            SizedBox(
              height: 32,
            ),
            Text(
              singleMusic.title!,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              singleMusic.artistName!,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 4),
            Slider(
              min: 0,
              max: audioProvider.duration.inSeconds.toDouble(),
              value: audioProvider.position.inSeconds.toDouble(),
              onChanged: (value) async {
                final position = Duration(seconds: value.toInt());
                await audioProvider.audioPlayer.seek(position);

                // Optional: Play audio if it was paused
                await audioProvider.audioPlayer.resume();
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(Utils.formatTime(audioProvider.position)),
                  Text(Utils.formatTime(
                      audioProvider.duration - audioProvider.position)),
                ],
              ),
            ),
            CircleAvatar(
              radius: 35,
              child: IconButton(
                onPressed: () async {
                  if (isPlaying && cuurentPlayedItem == 1) {
                    await audioProvider.audioPlayer.pause();
                    audioProvider.setPlayingState(true, -1);
                  } else {
                    String url = singleMusic.preview!;
                    await audioProvider.audioPlayer.play(UrlSource(url));
                    audioProvider.setPlayingState(true, 1);
                  }
                  // audioProvider.setPlayingState(!audioProvider.isPlaying, 1);
                },
                icon: Icon(
                  // audioProvider.isPlaying ? Icons.pause : Icons.play_arrow,
                  cuurentPlayedItem == 1 && isPlaying
                      ? Icons.pause
                      : Icons.play_arrow,
                ),
                iconSize: 50,
              ),
            )
          ],
        ),
      ),
    );
  }
}
