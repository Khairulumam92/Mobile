import 'package:flutter/material.dart';
import 'my_app.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Choose Theme', style: TextStyle(fontSize: 20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    MyApp.of(context)?.setThemeMode(ThemeMode.light);
                  },
                  child: Text('Light Theme'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    MyApp.of(context)?.setThemeMode(ThemeMode.dark);
                  },
                  child: Text('Dark Theme'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
