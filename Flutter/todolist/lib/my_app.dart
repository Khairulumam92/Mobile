import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';
import 'my_home_page.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  @override
  void initState() {
    super.initState();
    _loadAppData();
  }

  Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/app_data.json');
  }

  Future<void> _saveAppData() async {
    final file = await _getLocalFile();
    final data = {
      'themeMode': _themeMode.index,
      // Add other data to save here, e.g., tasks, notes
    };
    await file.writeAsString(jsonEncode(data));
  }

  Future<void> _loadAppData() async {
    try {
      final file = await _getLocalFile();
      if (await file.exists()) {
        final data = jsonDecode(await file.readAsString());
        setState(() {
          _themeMode = ThemeMode.values[data['themeMode'] ?? 0];
          // Load other data here, e.g., tasks, notes
        });
      }
    } catch (e) {
      print('Error loading app data: $e');
    }
  }

  void setThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
    _saveAppData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      home: const MyHomePage(title: 'Halo, Selamat Datang!'),
    );
  }
}
