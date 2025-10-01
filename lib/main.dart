import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FadingTextAnimation(),
    );
  }
}

class FadingTextAnimation extends StatefulWidget {
  @override
  State<FadingOpacityPage> createState() => _FadingOpacityPageState();
}

class _FadingOpacityPageState extends State<FadingOpacityPage> {
  bool _visible = true;
  void _toggle() => setState(() => _visible = !_visible);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fading Text Animation'),
      ),
      body: Center(
        child: AnimatedOpacity(
          opacity: _visible ? 1 : 0,
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOut,
          child: const Text(
            'Hello, Flutter!',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}