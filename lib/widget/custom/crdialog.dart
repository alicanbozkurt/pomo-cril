import 'package:flutter/material.dart';
import 'package:pomodoro_apps/utils/color_utils.dart';
import 'package:pomodoro_apps/utils/constants.dart';
import 'package:pomodoro_apps/widget/custom/crbutton.dart';

class ButtonDialog{
  final String titleAccept;
  final String titleDecline;
  

  ButtonDialog({this.titleAccept, this.titleDecline});

}
class CRDialog extends StatelessWidget{
  final String imgTitle;
  final String title;
  final String description;
  final ButtonDialog buttonDialog;
  final Function onAccept;
  final Function onDecline;

  CRDialog({this.imgTitle, this.title, this.description, this.buttonDialog, this.onAccept, this.onDecline});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8))
      ),
      child: Container(
        padding: EdgeInsets.all(16),
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset(imgTitle, width: 24,),
            Padding(padding: EdgeInsets.only(top: 4, bottom: 10), child:Text(title, style: TextStyle(fontFamily: Constants.font, fontWeight: FontWeight.bold,fontSize: 20, color: Colors.black),)),
            Padding(padding: EdgeInsets.only(bottom: 16), child:Text(description, style: TextStyle(fontFamily: Constants.font,fontSize: 14, color: Colors.black),)),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                GestureDetector(
                  child: Text(buttonDialog.titleDecline, style:TextStyle(fontFamily:Constants.font, fontSize: 14,color: ColorUtils.red)),
                  onTap: (){
                     Navigator.pop(context);
                     onDecline();
                  }
                    //Navigator.of(context).pop();
                ),
                Padding(padding:EdgeInsets.only(left: 16), 
                child:CRButton(
                    isWhite:true,
                    text:buttonDialog.titleAccept,
                    onClick:(){
                      Navigator.pop(context);
                      onAccept();
                    }
                  )
                )
              ],
            )
          ],
        ),
      )
    );
  }

}