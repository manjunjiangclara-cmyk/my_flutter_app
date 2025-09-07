import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/colors.dart';
import 'package:my_flutter_app/core/theme/fonts.dart';
import 'package:my_flutter_app/features/compose/presentation/screens/compose_screen.dart';
import 'package:my_flutter_app/features/memory/presentation/providers/memory_provider.dart';
import 'package:my_flutter_app/features/memory/presentation/screens/memory_screen.dart';
import 'package:my_flutter_app/features/settings/presentation/screens/settings_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MemoryData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Hibi',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: AppColors.colorScheme,
          scaffoldBackgroundColor: AppColors.background,
          textTheme: AppTypography.toTextTheme(),
          dividerColor: AppColors.border,
        ),
        home: const MyHomePage(title: 'Hibi'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    MemoryScreen(),
    ComposeScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Text(
              '📸',
              style: AppTypography.caption.copyWith(fontSize: 20),
            ),
            label: 'Memory',
          ),
          BottomNavigationBarItem(
            icon: Text(
              '✍️',
              style: AppTypography.caption.copyWith(fontSize: 20),
            ),
            label: 'Compose',
          ),
          BottomNavigationBarItem(
            icon: Text(
              '⚙️',
              style: AppTypography.caption.copyWith(fontSize: 20),
            ),
            label: 'Settings',
          ),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
