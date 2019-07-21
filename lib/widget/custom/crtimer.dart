import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pomodoro_apps/utils/color_utils.dart';

class CRTimer extends StatefulWidget{
  final List<Widget> children;
  CRTimer({this.children});

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
        border: Border.all(color: Colors.white, width: 14)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: widget.children
      ),
    );
  }

}