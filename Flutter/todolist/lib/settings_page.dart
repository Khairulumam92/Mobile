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
            SizedBox(height: 40),
            ListTile(
              title: Text('About Developer'),
              subtitle: Text('Information about the developer of this app.'),
              leading: Icon(Icons.person),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('About Developer'),
                      content: Text(
                          'This app was developed by khairul umam.\n\nContact us at: khairulumamku92@gmail.com'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
