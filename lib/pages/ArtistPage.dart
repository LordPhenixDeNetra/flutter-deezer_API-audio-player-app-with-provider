import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:my_n_music/models/Music.dart';
import 'package:my_n_music/pages/SingleMusicPage.dart';
import 'package:my_n_music/services/AudioProvider.dart';
import 'package:provider/provider.dart';

class ArtistPage extends StatelessWidget {

  AudioPlayer audioPlayer = AudioPlayer();

  // bool isPlaying = false;
  

  Duration duration = Duration.zero;

  Duration position = Duration.zero;

  final List<Music> listMusic;

  ArtistPage({super.key, required this.listMusic});

  @override
  Widget build(BuildContext context) {

    final audioProvider = Provider.of<AudioProvider>(context);
    bool isPlaying = audioProvider.isPlaying;
    int cuurentPlayedItem = audioProvider.itemCurrentPleyed;


    return Scaffold(
      backgroundColor: Color.fromARGB(255, 224, 249, 255),
        appBar: AppBar(
          title: Text("Music"),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 145, 233, 255),
          
        ),
        body: ListView.builder(
           itemCount: listMusic.length,
            itemBuilder: (BuildContext context, int position) {
              return ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SingleMusicPage(singleMusic: listMusic[position], isPlaying: isPlaying,),
                        ),
                  );
                },
                leading: CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 255, 200, 184),
                  radius: 40,
                  backgroundImage:
                      NetworkImage(listMusic[position].artistPicture!),
                ),
                title: Text(listMusic[position].title!),
                subtitle: Text(listMusic[position].artistName!),
                // trailing: Icon(Icons.play_arrow),
                trailing: CircleAvatar(
                    radius: 25,
                    child: IconButton(

                      onPressed: () async {
                        if (cuurentPlayedItem == position) {
                          await audioProvider.audioPlayer.pause();
                          audioProvider.setPlayingState(true, -1);
                        } else {
                          String url = listMusic[position].preview!;
                          await audioProvider.audioPlayer.play(UrlSource(url));
                          audioProvider.setPlayingState(true, position);
                        }
                        
                      },
                      icon: Icon(

                         cuurentPlayedItem == position && isPlaying ? Icons.pause : Icons.play_arrow,
                      ),
                      iconSize: 30,
                    )),
              );
            }));
  }
}
