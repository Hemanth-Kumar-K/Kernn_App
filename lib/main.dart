import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/memory_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/memory_list_screen.dart';

void main() {
  runApp(const TimeLockApp());
}

class TimeLockApp extends StatelessWidget {
  const TimeLockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MemoryProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'TimeLock',
            theme: ThemeData(
              brightness: Brightness.light,
              primarySwatch: Colors.blue,
              scaffoldBackgroundColor: Colors.white,
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              primarySwatch: Colors.blueGrey,
              scaffoldBackgroundColor: Colors.black,
            ),
            themeMode: themeProvider.themeMode,
            home: const MemoryListScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
