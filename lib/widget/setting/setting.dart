import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pomodoro_apps/utils/color_utils.dart';
import 'package:pomodoro_apps/utils/constants.dart';
import 'package:pomodoro_apps/widget/custom/back.dart';

class Setting extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => SettingState();

}

class SettingState extends State<Setting>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
      padding: EdgeInsets.only(top: 30, left: 20, bottom: 20, right: 20),
      child:Column(children: <Widget>[
              Container(
                height: 54,   
                child: 
                Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child:Back(isWhite: false,)
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Image.asset("assets/img/crillo.png", width:43, height:19),
                    ) 
                    
                  ],
                ),
              ),
              Flexible(
                child:Stack(
                  children: <Widget>[
                    ListView(
                      padding: EdgeInsets.only(bottom: 10),
                      children: <Widget>[
                        Padding(padding: EdgeInsets.only(left:8),child:Text("Application", style:TextStyle(fontFamily: Constants.font, fontWeight: FontWeight.bold,fontSize:21, color:Colors.black ))),
                        ItemSetting(textMessage: "Buy Premium Version", highlight: true,),
                        ItemSetting(textMessage: "Language", highlight: false,),
                        Padding(padding: EdgeInsets.only(top: 30, bottom: 8, left: 10), child:Text("About", style:TextStyle(fontFamily: Constants.font, fontWeight: FontWeight.bold,fontSize:21, color:Colors.black )),),
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
      ]
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
    return Container(
      margin: EdgeInsets.only(top: 5, bottom: 5),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        elevation: highlight? 4: 1,
        child: Container(
          padding: EdgeInsets.all(14),
          child: Text(textMessage, style:TextStyle(fontFamily: Constants.font, fontWeight: FontWeight.bold, fontSize:14, color: highlight? ColorUtils.blue_app :  Colors.black )),
        ),
      )
    );
  }

}