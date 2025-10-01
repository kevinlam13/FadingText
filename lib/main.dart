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
      home: HomeScreen(onToggleTheme: _toggleTheme, isDark: _mode == ThemeMode.dark),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final VoidCallback onToggleTheme;
  final bool isDark;
  const HomeScreen({super.key, required this.onToggleTheme, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fading Demo'),
        actions: [
          IconButton(
            tooltip: 'Toggle theme',
            onPressed: onToggleTheme,
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
          ),
        ],
      ),
      body: PageView(
        children: const [
          FadingOpacityPage(),
          SecondPageStub(),
        ],
      ),
    );
  }
}

class FadingOpacityPage extends StatefulWidget {
  const FadingOpacityPage({super.key});
  @override
  State<FadingOpacityPage> createState() => _FadingOpacityPageState();
}

class _FadingOpacityPageState extends State<FadingOpacityPage> {
  bool _visible = true;
  void _toggle() => setState(() => _visible = !_visible);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: _toggle, child: const Icon(Icons.play_arrow)),
      body: Center(
        child: AnimatedOpacity(
          opacity: _visible ? 1 : 0,
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOut,
          child: const Text('Hello, Flutter!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}

class SecondPageStub extends StatelessWidget {
  const SecondPageStub({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Second fade TBD'));
  }
}