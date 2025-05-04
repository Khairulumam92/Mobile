import 'package:flutter/material.dart';
import 'dart:async';
import 'package:vibration/vibration.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class PomodoroPage extends StatefulWidget {
  const PomodoroPage({super.key});

  @override
  _PomodoroPageState createState() => _PomodoroPageState();
}

class _PomodoroPageState extends State<PomodoroPage> {
  int _pomodoroTime = 25 * 60; // 25 minutes in seconds
  int _selectedPomodoroTime = 25 * 60; // Default selected duration
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
        } else if (_isPomodoroRunning && _pomodoroTime == 0) {
          _isPomodoroRunning = false;
          _playAlarm();
        }
      });
    });
  }

  void _playAlarm() {
    FlutterRingtonePlayer.playNotification();
    if (Vibration.hasVibrator() != null) {
      Vibration.vibrate(duration: 1000);
    }
  }

  void _startPomodoro() {
    setState(() {
      _isPomodoroRunning = true;
      _pomodoroTime = _selectedPomodoroTime; // Use the selected duration
    });
  }

  void _resetPomodoro() {
    setState(() {
      _pomodoroTime = _selectedPomodoroTime; // Reset to the selected duration
      _isPomodoroRunning = false;
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
              onPressed: _resetPomodoro,
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
                            title: Text('5 Menit'),
                            onTap: () {
                              setState(() {
                                _selectedPomodoroTime =
                                    5 * 60; // Update selected duration
                                _pomodoroTime = _selectedPomodoroTime;
                              });
                              Navigator.of(context).pop();
                            },
                          ),
                          ListTile(
                            title: Text('25 Menit'),
                            onTap: () {
                              setState(() {
                                _selectedPomodoroTime =
                                    25 * 60; // Update selected duration
                                _pomodoroTime = _selectedPomodoroTime;
                              });
                              Navigator.of(context).pop();
                            },
                          ),
                          ListTile(
                            title: Text('30 Menit'),
                            onTap: () {
                              setState(() {
                                _selectedPomodoroTime =
                                    30 * 60; // Update selected duration
                                _pomodoroTime = _selectedPomodoroTime;
                              });
                              Navigator.of(context).pop();
                            },
                          ),
                          ListTile(
                            title: Text('45 Menit'),
                            onTap: () {
                              setState(() {
                                _selectedPomodoroTime =
                                    45 * 60; // Update selected duration
                                _pomodoroTime = _selectedPomodoroTime;
                              });
                              Navigator.of(context).pop();
                            },
                          ),
                          ListTile(
                            title: Text('Custom Durasi'),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  TextEditingController
                                      customDurationController =
                                      TextEditingController();
                                  return AlertDialog(
                                    title: Text('Masukkan Durasi (menit)'),
                                    content: TextField(
                                      controller: customDurationController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        hintText: 'Contoh: 10',
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Batal'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          final customMinutes = int.tryParse(
                                              customDurationController.text);
                                          if (customMinutes != null &&
                                              customMinutes > 0) {
                                            setState(() {
                                              _selectedPomodoroTime =
                                                  customMinutes * 60;
                                              _pomodoroTime =
                                                  _selectedPomodoroTime;
                                            });
                                          }
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Simpan'),
                                      ),
                                    ],
                                  );
                                },
                              );
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
