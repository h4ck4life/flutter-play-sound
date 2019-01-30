import 'package:flutter/material.dart';
import "package:audioplayers/audio_cache.dart";
import 'package:audioplayers/audioplayers.dart';

AudioCache audioCache = new AudioCache();

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'Bunyi Loceng'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _buttonLabel = 'Ring!';
  MaterialColor _buttonColor = Colors.green;
  AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  void _playBellSound() async {
    if (_isPlaying == false) {
      setState(() => _isPlaying = true);
      setState(() => _buttonLabel = 'Stop');
      setState(() => _buttonColor = Colors.red);
      audioCache.play('Handbell-sound.mp3').then((audioPlayer) {
        setState(() => _audioPlayer = audioPlayer);
        audioPlayer.completionHandler = () {
          setState(() => _isPlaying = false);
          setState(() => _buttonLabel = 'Ring!');
          setState(() => _buttonColor = Colors.green);
        };
      });
    } else {
      _audioPlayer.stop();
      setState(() => _isPlaying = false);
      setState(() => _buttonLabel = 'Ring!');
      setState(() => _buttonColor = Colors.green);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton.icon(
                icon: Icon(
                  Icons.alarm,
                  size: 50,
                ),
                onPressed: _playBellSound,
                color: _buttonColor,
                label: Container(
                  padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
                  child: Text(
                    _buttonLabel,
                    style: TextStyle(color: Colors.white, fontSize: 50),
                  ),
                )),
          ],
        ),
      ),
      /* floatingActionButton: FloatingActionButton(
        onPressed: _playBellSound,
        tooltip: 'Ring the bell',
        child: Icon(Icons.audiotrack),
      ), */
    );
  }
}
