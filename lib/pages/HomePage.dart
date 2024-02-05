// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, file_names
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:my_n_music/models/Music.dart';
import 'package:http/http.dart' as http;
import 'package:my_n_music/pages/ArtistPage.dart';
import 'package:my_n_music/services/AudioProvider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  TextEditingController _controller = TextEditingController();

  String recherche = "";

  @override
  Widget build(BuildContext context) {
    // final audioPlayerModel = Provider.of<AudioProvider>(context);
    final audioProvider = Provider.of<AudioProvider>(context);
    // bool isPlaying = audioProvider.isPlaying;
    // int cuurentPlayedItem = 1;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 224, 249, 255),
      body: FutureBuilder(
        future: getArtiste(recherche),
        builder: (context, snapshot) {
          
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: audioProvider.listOfListsMusic.length,
                itemBuilder: (BuildContext context, int position) {

                  return Column(
                    children: [
                      ListTile(
                        onTap: () {
                          Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ArtistPage(listMusic: audioProvider.listOfListsMusic[position]),
                            ),
                          );
                        },
                        leading: CircleAvatar(
                          backgroundColor: Color.fromARGB(255, 255, 200, 184),
                          radius: 40,
                          backgroundImage:
                              
                              NetworkImage(audioProvider
                                  .listOfListsMusic[position][0].artistPicture!),
                        ),
                        
                        title: Text(audioProvider
                            .listOfListsMusic[position][0].artistName!),
                        subtitle: Text(audioProvider
                            .listOfListsMusic[position][0].artistName!),

                        // trailing: Icon(Icons.play_arrow),
                        trailing: CircleAvatar(
                            radius: 25,
                            child: IconButton(
                              onPressed: () async {
                                null;
                              },
                              icon: Icon(
                                Icons.queue_music_rounded,
                              ),
                              iconSize: 30,
                            )),
                      ),
                      Divider()
                    ],
                  );
                });
          } else {
            // return Center(child: CircularProgressIndicator());
            return Center(
                child: Text(
              "Pas de musique pour le moment 😒",
              style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ));
          }
        },
      ),
      appBar: AppBar(
        title: Text("Music"),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 145, 233, 255),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Recherchez Un Artiste"),
                  content: TextField(

                    controller: _controller,
                  ),
                  actions: [
                    ElevatedButton(
                        onPressed: () async {
                          var counter = 0;

                          recherche = _controller.text;

                          // Vérifiez si l'artiste est déjà présent dans la liste
                          for (var list in audioProvider.listOfListsMusic) {
                            for (var item in list) {
                              if (item.artistName == recherche) {
                                counter += 1;
                              } else {}
                            }
                          }

                          if (counter > 1) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("L'artiste existe dejas"),
                              backgroundColor: Colors.deepOrange,
                              dismissDirection: DismissDirection.up,

                            ));
                          } else {
                            
                            List<Music> listMusic = await getArtiste(recherche);

                            if (listMusic.isNotEmpty) {
                              audioProvider.setMusicList(listMusic);
                            }
                            // recherche = "";
                            Navigator.pop(context);
                          }
                        },
                        child: Text("Valider")),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Annuler"))
                  ],
                );
              });
        },
        child: Icon(Icons.manage_search_sharp),
      ),
    );
  }
}

Future<List<Music>> getArtiste(String user_Artiste) async {
  List<Music> listMusic = [];

  String url = "http://api.deezer.com/search?q=" + user_Artiste;

  var response = await http.get(Uri.parse(url));

  var responseJson = jsonDecode(response.body);

  for (var music in responseJson["data"]) {
    listMusic.add(Music.fromjson(music));
  }

  return listMusic;
}

