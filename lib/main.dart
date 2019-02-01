import 'package:flutter/material.dart';
import "package:audioplayers/audio_cache.dart";
import 'package:audioplayers/audioplayers.dart';
import 'package:sensors/sensors.dart';

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
      home: MyHomePage(title: 'Handbell'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  String _buttonLabel = 'Ring!';
  MaterialColor _buttonColor = Colors.green;
  AudioPlayer _audioPlayer;
  bool _bellSwitch = false;
  Color _bellColor = Colors.black54;
  bool _isPlaying = false;

  Animation<double> _animation;
  AnimationController _animationController;

  void _playDingOnce() async {
    audioCache.play('DeskBell.mp3');
  }

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
  void initState() {
    super.initState();
    accelerometerEvents.listen((AccelerometerEvent event) {
      if (_bellSwitch) {
        if (event.x > 5.0 || event.x < -5.0) {
          _animationController..forward();
          _playDingOnce();
        }
      }
    });

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
      reverseCurve: Curves.easeOut,
    );

    _animation.addListener((){
      if(_animation.value > 0.05) {
        _animationController..reverse();
      }
    });
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
            /* RaisedButton.icon(
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
                )), */
            GestureDetector(
                onTap: () {
                  if (_bellSwitch) {
                    _animationController..reset();
                    setState(() => _bellSwitch = false);
                    setState(() => _bellColor = Colors.black54);
                  } else {
                    _animationController..forward();
                    setState(() => _bellSwitch = true);
                    setState(() => _bellColor = Colors.transparent);
                  }
                },
                child: RotationTransition(
                  alignment: Alignment(0.0, 0.0),
                  turns: _animation,
                  child: Image.asset('bell.png',
                      colorBlendMode: BlendMode.srcATop, color: _bellColor),
                )),
            Container(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
              child: Text(
                'Made with ♥ by Alif',
                style: TextStyle(color: Colors.white30, fontSize: 15, fontWeight: FontWeight.bold),
              ),
            )
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
