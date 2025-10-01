import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

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

class HomeScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool isDark;
  const HomeScreen({super.key, required this.onToggleTheme, required this.isDark});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _controller = PageController();
  Color _textColor = Colors.teal;
  bool _showFrame = false;

  Future<void> _pickColor() async {
    Color temp = _textColor;
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Pick text color'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: temp,
            onColorChanged: (c) => temp = c,
            enableAlpha: false,
            portraitOnly: true,
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () { setState(() => _textColor = temp); Navigator.pop(context); },
            child: const Text('Select'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fading Demo'),
        actions: [
          IconButton(onPressed: _pickColor, icon: const Icon(Icons.palette)),
          IconButton(
            tooltip: 'Toggle theme',
            onPressed: widget.onToggleTheme,
            icon: Icon(widget.isDark ? Icons.light_mode : Icons.dark_mode),
          ),
        ],
      ),
      body: Column(
        children: [
          // rounded image + frame toggle
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    decoration: BoxDecoration(
                      border: _showFrame ? Border.all(width: 3) : null,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Image.asset(
                      'assets/images/my_photo.png',  // update if your name differs
                      width: 220,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SwitchListTile(
                    title: const Text('Show Frame'),
                    value: _showFrame,
                    onChanged: (v) => setState(() => _showFrame = v),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 0),
          Expanded(
            child: PageView(
              controller: _controller,
              children: [
                FadingOpacityPage(textColor: _textColor),  // bugfix: now uses color
                FadingSwitcherPage(textColor: _textColor),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FadingOpacityPage extends StatefulWidget {
  final Color textColor;
  const FadingOpacityPage({super.key, required this.textColor});
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
          child: Text(                      // <-- removed const so color can change
            'Hello, Flutter!',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: widget.textColor),
          ),
        ),
      ),
    );
  }
}

class FadingSwitcherPage extends StatefulWidget {
  final Color textColor;
  const FadingSwitcherPage({super.key, required this.textColor});
  @override
  State<FadingSwitcherPage> createState() => _FadingSwitcherPageState();
}

class _FadingSwitcherPageState extends State<FadingSwitcherPage> {
  bool _showHello = true;
  void _toggle() => setState(() => _showHello = !_showHello);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: _toggle, child: const Icon(Icons.play_arrow)),
      body: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 2500),
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          transitionBuilder: (child, anim) => FadeTransition(opacity: anim, child: child),
          child: Text(
            _showHello ? 'Hello, Flutter!' : 'Different Fade ✨',
            key: ValueKey(_showHello),
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: widget.textColor),
          ),
        ),
      ),
    );
  }
}
