// Restored the PomodoroPage class to its original state
import 'package:flutter/material.dart';
import 'dart:async';

class PomodoroPage extends StatefulWidget {
  const PomodoroPage({super.key});

  @override
  _PomodoroPageState createState() => _PomodoroPageState();
}

class _PomodoroPageState extends State<PomodoroPage> {
  int _pomodoroTime = 25 * 60; // 25 minutes in seconds
  bool _isPomodoroRunning = false;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startClock();
  }

  void _startClock() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_isPomodoroRunning && _pomodoroTime > 0) {
          _pomodoroTime--;
        }
      });
    });
  }

  void _startPomodoro() {
    setState(() {
      _isPomodoroRunning = true;
      _pomodoroTime = 25 * 60;
    });
  }

  void _stopPomodoro() {
    setState(() {
      _isPomodoroRunning = false;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pomodoroMinutes = (_pomodoroTime ~/ 60).toString().padLeft(2, '0');
    final pomodoroSeconds = (_pomodoroTime % 60).toString().padLeft(2, '0');

    return Scaffold(
      appBar: AppBar(
        title: Text('Pomodoro Timer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Pomodoro Timer',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text('$pomodoroMinutes:$pomodoroSeconds',
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _isPomodoroRunning ? null : _startPomodoro,
                  child: Text('Mulai'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _isPomodoroRunning ? _stopPomodoro : null,
                  child: Text('Berhenti'),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _pomodoroTime = 25 * 60; // Reset to default 25 minutes
                  _isPomodoroRunning = false;
                });
              },
              icon: Icon(Icons.refresh),
              label: Text('Reset Pomodoro'),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Pilih Durasi Pomodoro'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: Text('25 Menit'),
                            onTap: () {
                              setState(() {
                                _pomodoroTime = 25 * 60;
                              });
                              Navigator.of(context).pop();
                            },
                          ),
                          ListTile(
                            title: Text('30 Menit'),
                            onTap: () {
                              setState(() {
                                _pomodoroTime = 30 * 60;
                              });
                              Navigator.of(context).pop();
                            },
                          ),
                          ListTile(
                            title: Text('45 Menit'),
                            onTap: () {
                              setState(() {
                                _pomodoroTime = 45 * 60;
                              });
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              icon: Icon(Icons.timer),
              label: Text('Pilih Durasi'),
            ),
          ],
        ),
      ),
    );
  }
}
