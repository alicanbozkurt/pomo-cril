import 'package:flutter/material.dart';
import 'package:pomodoro_apps/utils/constants.dart';

class Back extends StatelessWidget{
  final bool isWhite;
  Back({this.isWhite});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child:Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(icon: Image.asset(isWhite ? "assets/img/back_white.png" : "assets/img/back_blue.png", width: 9, height: 16,), onPressed: (){
                          Navigator.of(context).pop();
                        }),
            Text("Back", style: TextStyle(color: isWhite? Colors.white : Colors.black, fontFamily: Constants.font, fontSize: 12)),
              

          ],
        ),
        onTap: (){
          Navigator.of(context).pop();
        },
    );
  }

}