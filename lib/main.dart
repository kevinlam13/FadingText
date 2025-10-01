import 'package:flutter/material.dart';

void main() => runApp(const AppRoot());

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});
  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  ThemeMode _mode = ThemeMode.light;
  void _toggleTheme() =>
      setState(() => _mode = _mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fading Text',
      debugShowCheckedModeBanner: false,
      themeMode: _mode,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo, brightness: Brightness.light),
      darkTheme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo, brightness: Brightness.dark),
      home: FadingOpacityPage(onToggleTheme: _toggleTheme, isDark: _mode == ThemeMode.dark),
    );
  }
}

class FadingOpacityPage extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool isDark;
  const FadingOpacityPage({super.key, required this.onToggleTheme, required this.isDark});

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
        title: const Text('Fading (AnimatedOpacity)'),
        actions: [
          IconButton(
            tooltip: 'Toggle theme',
            onPressed: widget.onToggleTheme,
            icon: Icon(widget.isDark ? Icons.light_mode : Icons.dark_mode),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggle,
        child: const Icon(Icons.play_arrow),
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
