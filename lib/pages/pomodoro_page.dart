import 'dart:async';
import 'package:flutter/material.dart';

class PomodoroPage extends StatefulWidget {
  @override
  _PomodoroPageState createState() => _PomodoroPageState();
}

class _PomodoroPageState extends State<PomodoroPage> {
  int pomodoroDuration = 25 * 60; // default 25 minutes
  int breakDuration = 5 * 60; // default 5 minutes
  int remainingSeconds = 25 * 60;
  bool isRunning = false;
  bool isBreak = false;
  Timer? timer;

  void _startTimer() {
    setState(() {
      isRunning = true;
    });
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingSeconds > 0) {
          remainingSeconds--;
        } else {
          timer.cancel();
          isBreak = !isBreak;
          remainingSeconds = isBreak ? breakDuration : pomodoroDuration;
          _startTimer();
        }
      });
    });
  }

  void _stopTimer() {
    timer?.cancel();
    setState(() {
      isRunning = false;
      remainingSeconds = pomodoroDuration;
      isBreak = false;
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return "$minutes:${secs.toString().padLeft(2, '0')}";
  }

  Future<void> _selectTime(BuildContext context, bool isPomodoro) async {
    final TimeOfDay? result = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: isPomodoro ? pomodoroDuration ~/ 60 : breakDuration ~/ 60,
        minute: isPomodoro ? pomodoroDuration % 60 : breakDuration % 60,
      ),
    );
    if (result != null) {
      setState(() {
        int duration = result.hour * 60 + result.minute;
        if (isPomodoro) {
          pomodoroDuration = duration * 60;
          if (!isRunning && !isBreak) {
            remainingSeconds = pomodoroDuration;
          }
        } else {
          breakDuration = duration * 60;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pomodoro Tekniği"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                isBreak ? "Mola Zamanı" : "Çalışma Zamanı",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Text(
                _formatTime(remainingSeconds),
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              isRunning
                  ? ElevatedButton(
                      onPressed: _stopTimer,
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        textStyle: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.redAccent,
                      ),
                      child: const Text("Durdur"),
                    )
                  : ElevatedButton(
                      onPressed: _startTimer,
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        textStyle: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.green,
                      ),
                      child: const Text("Başlat"),
                    ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _selectTime(context, true),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Colors.blueAccent,
                ),
                child: const Text("Çalışma Süresi Seç"),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => _selectTime(context, false),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Colors.orangeAccent,
                ),
                child: const Text("Mola Süresi Seç"),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _stopTimer,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Colors.grey,
                ),
                child: const Text("Sıfırla"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
