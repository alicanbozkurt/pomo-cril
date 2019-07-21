import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pomodoro_apps/utils/color_utils.dart';
import 'package:pomodoro_apps/utils/constants.dart';

class Setting extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => SettingState();

}

class SettingState extends State<Setting>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: Padding(
      padding: EdgeInsets.all(30),
      child:Container(
      child:Stack(
        children: <Widget>[
          ListView(
            padding: EdgeInsets.only(bottom: 10),
            children: <Widget>[
              Text("Application", style:TextStyle(fontFamily: Constants.font, fontWeight: FontWeight.bold,fontSize:21, color:Colors.black )),
              ItemSetting(textMessage: "Buy Premium Version", highlight: true,),
              ItemSetting(textMessage: "Language", highlight: false,),
              Padding(padding: EdgeInsets.only(top: 30, bottom: 8), child:Text("About", style:TextStyle(fontFamily: Constants.font, fontWeight: FontWeight.bold,fontSize:21, color:Colors.black )),),
              ItemSetting(textMessage: "FAQ", highlight: false),
              ItemSetting(textMessage: "Rate Crillo", highlight: false),
              ItemSetting(textMessage: "Give us feedback", highlight: false),
              ItemSetting(textMessage: "Privacy Policy", highlight: false),
              ItemSetting(textMessage: "Website", highlight: false),
            ],

          ),
          Positioned(
            bottom: 1,
            child: Container(
              padding: EdgeInsets.only(top: 8),
              width: MediaQuery.of(context).size.width - 40,
              child:Text("All Rights Reserved 2019 ©Crillo", textAlign: TextAlign.center, style:TextStyle(fontFamily: Constants.font, fontSize:16, color:Colors.black ))
            )
          )
        ],
      ),
      )
      )
    );
  }

  

}

class ItemSetting extends StatelessWidget{
  final String textMessage;
  final bool highlight;
  ItemSetting({this.textMessage, this.highlight});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5, bottom: 5),
      child: Card(
        elevation: highlight? 4: 1,
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(14),
          child: Text(textMessage, style:TextStyle(fontFamily: Constants.font, fontWeight: FontWeight.bold, fontSize:14, color: highlight? ColorUtils.blue_app :  Colors.black )),
        ),
      )
    );
  }

}