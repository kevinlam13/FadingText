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
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.dark,
      ),
      home: HomeScreen(onToggleTheme: _toggleTheme),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  const HomeScreen({super.key, required this.onToggleTheme});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _controller = PageController();
  Color _textColor = Colors.teal;

  Future<void> _pickColor() async {
    final palette = <Color>[
      Colors.teal,
      Colors.indigo,
      Colors.red,
      Colors.orange,
      Colors.green,
      Colors.blue,
      Colors.purple,
      Colors.pink,
      Colors.brown,
      Colors.cyan,
      Colors.lime,
      Colors.amber,
      Colors.grey,
      Colors.black,
      Colors.white,
    ];
    Color selected = _textColor;

    await showDialog(
      context: context,
      builder: (_) {
        Color tempSelected = selected;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Pick text color'),
              content: SizedBox(
                width: 260,
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: palette.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemBuilder: (_, i) {
                    final c = palette[i];
                    final isSel = c.value == tempSelected.value;
                    return InkWell(
                      onTap: () => setDialogState(() => tempSelected = c),
                      child: Container(
                        decoration: BoxDecoration(
                          color: c,
                          shape: BoxShape.circle,
                          border: Border.all(width: isSel ? 3 : 1.5),
                        ),
                      ),
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    setState(() => _textColor = tempSelected);
                    Navigator.pop(context);
                  },
                  child: const Text('Select'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fading Demo'),
        actions: [
          IconButton(onPressed: _pickColor, icon: const Icon(Icons.palette)),
          IconButton(
            tooltip: 'Toggle theme',
            onPressed: widget.onToggleTheme,
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
          ),
        ],
      ),
      body: PageView(
        controller: _controller,
        children: [
          FadingOpacityPage(textColor: _textColor),
          FadingSwitcherPage(textColor: _textColor),
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
      floatingActionButton:
          FloatingActionButton(onPressed: _toggle, child: const Icon(Icons.play_arrow)),
      body: Center(
        child: AnimatedOpacity(
          opacity: _visible ? 1 : 0,
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOut,
          child: Text(
            'Hello, Flutter!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: widget.textColor,
            ),
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
      floatingActionButton:
          FloatingActionButton(onPressed: _toggle, child: const Icon(Icons.play_arrow)),
      body: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 800),
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          transitionBuilder: (child, anim) =>
              FadeTransition(opacity: anim, child: child),
          child: Text(
            _showHello ? 'Hello, Flutter!' : 'Different Fade ✨',
            key: ValueKey(_showHello),
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: widget.textColor,
            ),
          ),
        ),
      ),
    );
  }
}