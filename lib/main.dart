import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Heartbeat Animation',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        useMaterial3: true,
      ),
      home: const HeartbeatPage(),
    );
  }
}

class HeartbeatPage extends StatefulWidget {
  const HeartbeatPage({super.key});

  @override
  _HeartbeatPageState createState() => _HeartbeatPageState();
}

class _HeartbeatPageState extends State<HeartbeatPage> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late AnimationController _fadeController;
  Timer? _timer;
  int _start = 10;
  int _quoteIndex = 0;
  List<String> _quotes = [
    "You hold the key to my heart.",
    "Every love story is beautiful, but ours is my favorite.",
    "Together is my favorite place to be.",
    "I love you more than yesterday and less than tomorrow.",
  ];

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            _controller.stop();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  void cycleQuotes() {
    _timer = Timer.periodic(
      Duration(seconds: 5), // Change quotes every 5 seconds
      (Timer timer) {
        setState(() {
          _quoteIndex = (_quoteIndex + 1) % _quotes.length;
          _fadeController.forward(from: 0.0);
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.75, end: 1.25).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    
    _fadeController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _fadeController.forward();

    cycleQuotes();
  }

  @override
  void dispose() {
    _controller.dispose();
    _fadeController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Heartbeat Animation'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FadeTransition(
              opacity: _fadeController,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _quotes[_quoteIndex],
                  style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                '$_start',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _animation.value,
                  child: Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/heart.png'), // Ensure this path matches your asset path
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: FloatingActionButton(
                onPressed: () {
                  if (!_controller.isAnimating) {
                    _controller.repeat(reverse: true);
                    startTimer();
                  }
                },
                tooltip: 'Start Animation',
                child: const Icon(Icons.play_arrow),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
