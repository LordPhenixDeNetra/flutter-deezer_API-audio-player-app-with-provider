

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:my_n_music/models/Music.dart';

class AudioProvider extends ChangeNotifier {
  
  final AudioPlayer audioPlayer = AudioPlayer();

  bool isPlaying = false;
  final artistList = [];

  final List<List<Music>> listOfListsMusic = [];

  int itemCurrentPleyed = -1;

  String recherche = "";

  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  void setPlayingState(bool cuurentPlayed, int index) {
    isPlaying = cuurentPlayed;
    itemCurrentPleyed = index;
    notifyListeners();
  }

  void setDuration(Duration newDuration) {
    duration = newDuration;
    notifyListeners();
  }

  // void setItemCurrentPleyed(bool cuurentPlayed, int index) {
  //   isPlaying = cuurentPlayed;
  //   itemCurrentPleyed = index;
  //   notifyListeners();
  // }

  void setPosition(Duration newPosition) {
    position = newPosition;
    notifyListeners();
  }

  void setMusicList(List<Music> list){
    listOfListsMusic.add(list);
    notifyListeners();
  }

  

  // void set(List<Music> list){
  //   listOfListsMusic.add(list);
  //   notifyListeners();
  // }
}