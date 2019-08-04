import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pomodoro_apps/utils/color_utils.dart';
import 'package:pomodoro_apps/utils/constants.dart';

class CRButton extends StatelessWidget{
  final String text;
  final Function onClick;
  final bool isWhite;
  CRButton({this.onClick, this.text, this.isWhite});

  @override
  Widget build(BuildContext context) {
     return RaisedButton(
       color: isWhite? Colors.white : ColorUtils.blue_button,
      onPressed: (){
        onClick();
      },
      child: Text(
          text, style: TextStyle(fontFamily: Constants.font, color: isWhite? ColorUtils.blue_button :Colors.white ),
      ),
       shape: new RoundedRectangleBorder(
         side: BorderSide(color: isWhite? ColorUtils.blue_button :Colors.white),
         borderRadius: new BorderRadius.all(Radius.circular(8)),
       )
     
    );
  }
  

}