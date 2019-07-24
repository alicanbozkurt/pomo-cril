import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pomodoro_apps/utils/color_utils.dart';
import 'package:pomodoro_apps/utils/constants.dart';

class CRButton extends StatelessWidget{
  final String text;
  final Function onClick;
  CRButton({this.onClick, this.text});

  @override
  Widget build(BuildContext context) {
     return RaisedButton(
       color: ColorUtils.blue_button,
      onPressed: (){
        onClick();
      },
      child: Text(
          text, style: TextStyle(fontFamily: Constants.font, color: Colors.white),
      ),
       shape: new RoundedRectangleBorder(
         side: BorderSide(color: Colors.white),
         borderRadius: new BorderRadius.all(Radius.circular(8)),
       )
     
    );
  }
  

}