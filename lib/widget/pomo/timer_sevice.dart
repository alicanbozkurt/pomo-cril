import 'dart:async';
import 'package:flutter/material.dart';

class TimerService extends ChangeNotifier{
  Stopwatch stopwatch;
  Timer timer;

  Duration get currentDuration => _currentDuration;
  Duration _currentDuration = Duration.zero;

  bool get isRunning => timer != null;

  TimerService(){
    stopwatch = Stopwatch();
  }
}