import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pomodoro_apps/utils/color_utils.dart';
import 'package:pomodoro_apps/widget/pomo/pomo_tracker.dart';

class CRTimer extends StatefulWidget{
  final List<Widget> children;
  final StateTracker stateTracker;
  CRTimer({this.children, this.stateTracker});

  @override
  State<StatefulWidget> createState() => CRTimerState();

}

class CRTimerState extends State<CRTimer>{
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 212,
      height: 212,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: ColorUtils.blue_app,
        border: Border.all(color: widget.stateTracker == StateTracker.IDLE ? Colors.white : ColorUtils.blue_focus, width: 14)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: widget.children
      ),
    );
  }

}