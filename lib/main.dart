import 'dart:async';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final _player = AudioPlayer();
  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    _setupAudioPlayer();
    print("initState called");
  }

  @override
  Widget build(BuildContext context) {
    print("build called");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Nitin Music Player'),
      ),
      body:
      SafeArea(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [

                _playbackControllerButton(),
                _progressBar(),
                Row(
                  children: [
                    Expanded(child: _controlButtons()),
                    Expanded(child: _volumeButtons())
                  ],
                )
              ],
            ),
          )



      )
    );
  }

  Future<void> _setupAudioPlayer() async {
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stacktrace) {
          print("A stream error occured:$e");
        });
    try {
      // await _player.setAudioSource(AudioSource.uri(Uri.parse(
      //     "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3")));
      await AudioPlayer.clearAssetCache();
      await _player.setAsset('assets/song4.mp3');
    } catch (e) {
      print("Error");
    }
  }

    Widget _playbackControllerButton(){
      return StreamBuilder<PlayerState>(stream: _player.playerStateStream, builder: (context,snapshot){
        final playerState = snapshot.data;
        final processingState = snapshot.data?.processingState;
        final playing = snapshot.data?.playing;
        if(processingState == ProcessingState.loading || processingState == ProcessingState.buffering){
          return Container(
            margin: const EdgeInsets.all(8.0),
            width: 64,
            height: 64,
            child: const CircularProgressIndicator(),
          );
        }
        else if(playing!=true){
          return IconButton(onPressed: _player.play,
          icon: const Icon(Icons.play_arrow),iconSize: 60,);
        }
        else if(processingState!=ProcessingState.completed){
             return IconButton(onPressed: _player.pause,
                 icon: const Icon(Icons.pause),iconSize: 60,);
        }
        else {
            return IconButton(onPressed: ()=> _player.seek(Duration.zero), icon: const Icon(Icons.replay),iconSize: 62,);
        }
        return const SizedBox();
      });
    }

    Widget _progressBar(){
        return StreamBuilder<Duration>(stream: _player.positionStream, builder: (context,snapshot){
          return ProgressBar(progress: snapshot.data ?? Duration.zero,
              total: _player.duration ?? Duration.zero,
              buffered:_player.bufferedPosition,
              onSeek: (duration){
                _player.seek(duration);
              });
        });
    }

    Widget _controlButtons(){
        return StreamBuilder(stream: _player.speedStream, builder: (context,snapshot){
            return Column(
              children: [
                Icon(
                  Icons.speed,
                ),
                Slider(
                  divisions: 3,
                  value: snapshot.data ?? 1,
                  onChanged: (value) async {
                    await _player.setSpeed(value);
                  },
                )
              ],
            );
        });
    }

    Widget _volumeButtons(){
        return StreamBuilder(stream: _player.volumeStream, builder: (context,snapshot){
          return Column(
              mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.volume_up
              ),
              Slider(value: snapshot.data ?? 1, onChanged: (value) async {
                  await _player.setVolume(value);
              })

            ],
          );
        });
    }
}
