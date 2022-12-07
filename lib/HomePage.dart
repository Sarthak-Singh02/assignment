import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationIconController1;

  late AudioPlayer audioPlayer;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  bool issongplaying = false;
  String formatTime(int seconds) {
    return '${(Duration(seconds: seconds))}'
        .split('.')[0]
        .padLeft(4, '0')
        .toString()
        .substring(2, 7);
  }

  void initState() {
    super.initState();
    audioPlayer = new AudioPlayer();
    _animationIconController1 = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 750),
      reverseDuration: Duration(milliseconds: 750),
    );
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        issongplaying = state == PlayerState.playing;
      });
    });

    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0XFFF1E2FF), Color.fromARGB(255, 210, 206, 250)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            stops: [0.4, 0.7],
            tileMode: TileMode.repeated,
          ),
        ),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Container(
                  alignment: Alignment.topLeft,
                  width: MediaQuery.of(context).size.width,
                  child: const Icon(CupertinoIcons.back)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60.0),
              child: Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height / 2,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Lottie.asset('assets/lottie.json'),
                  )),
            ),
            Container(
                alignment: Alignment.center,
                child: const Text(
                  "Music",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500),
                )),
            Slider(
              activeColor: Color(0xffBB86FC),
              inactiveColor: Colors.white,
              min: 0,
              max: duration.inSeconds.toDouble(),
              value: position.inSeconds.toDouble(),
              onChanged: (value) {
                final position = Duration(seconds: value.toInt());
                audioPlayer.seek(position);
                audioPlayer.resume();
                _animationIconController1.forward();
              },
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(formatTime(position.inSeconds)),
                  Text(formatTime((duration).inSeconds)),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                
                Icon(
                  Icons.refresh,
                  color: Colors.black,
                ),
                Icon(
                  CupertinoIcons.backward_fill,
                  color: Colors.black,
                ),
                GestureDetector(
                  onTap: () {
                    setState(
                      () {
                        if (!issongplaying) {
                          audioPlayer.play(UrlSource(
                              "https://firebasestorage.googleapis.com/v0/b/assignmnet-f9870.appspot.com/o/o84t0LSOBwI_160.mp3?alt=media&token=29456649-0995-46fc-afa8-3936d10e1cd3"));
                        } else {
                          audioPlayer.pause();
                        }
                        issongplaying
                            ? _animationIconController1.reverse()
                            : _animationIconController1.forward();
                        issongplaying = !issongplaying;
                      },
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AnimatedIcon(
                          icon: AnimatedIcons.play_pause,
                          size: 55,
                          progress: _animationIconController1,
                          color: Color(0xffBB86FC),
                        ),
                      ),
                    ),
                  ),
                ),
                Icon(
                  CupertinoIcons.forward_fill,
                  color: Colors.black,
                ),
                Icon(
                  Icons.repeat,
                  color: Colors.black,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
