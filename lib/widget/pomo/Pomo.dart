
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pomodoro_apps/model/cril_data.dart';
import 'package:pomodoro_apps/utils/animation.dart';
import 'package:pomodoro_apps/utils/color_utils.dart';
import 'package:pomodoro_apps/utils/constants.dart';
import 'package:pomodoro_apps/widget/custom/back.dart';
import 'package:pomodoro_apps/widget/custom/crbutton.dart';
import 'package:pomodoro_apps/widget/custom/critem.dart';
import 'package:pomodoro_apps/widget/custom/group_timer.dart';
import 'package:pomodoro_apps/widget/custom/radio_focus.dart';
import 'package:pomodoro_apps/widget/home/home.dart';
import 'package:pomodoro_apps/widget/pomo/pomo_tracker.dart';

class Pomo extends StatefulWidget {
  final HomeState homeState;
  Pomo({this.homeState});
  @override
  State<StatefulWidget> createState() => PomoState();
}

class PomoState extends State<Pomo> {
  double sliderValue = 4;
  String strSlider = "4";
  bool isRinging = true;
  bool isVibrate = true;
  int longBreakValue = 15;
  Focussing focussing = Focussing.Relax;
  String crilName = "";

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inputController = TextEditingController();
    return Scaffold(
        // key: _scaffoldKey,
        body: Container(
            margin: EdgeInsets.only(top: 24),
            height: MediaQuery.of(context).size.height,
              child: 
                Column(children: <Widget>[
                  Container(

                    height: 54,
                    padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
                    decoration: BoxDecoration(
                        color: ColorUtils.blue_app,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16))),
                    child: 
                    Stack(
                      children: <Widget>[
                      Back(isWhite: true,),
                        Align(
                          alignment: Alignment.center,
                          child:Text("Start a Cril", textAlign: TextAlign.center, style: TextStyle(fontFamily: Constants.font, fontSize: 14, color: Colors.white),)
                        )
                        
                      ],
                    ),
                  ),
                  Flexible(
                  child: Container(
                    color: ColorUtils.blue_app,
                    padding: EdgeInsets.only(left: 30, right: 30, bottom: 16),
                    child: ListView(
                      children: <Widget>[
                        Text("Crill Name",
                            style: TextStyle(
                                fontFamily: Constants.font,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.white)),
                        Padding(
                            padding: EdgeInsets.only(top: 5, bottom: 20),
                            child: Container(
                              padding: EdgeInsets.only(left: 5, right: 5),
                              color: ColorUtils.blue_item,
                              child:TextField(
                                onChanged: (value){
                                  crilName = value;
                                },
                                style:TextStyle(fontFamily: Constants.font, color: Colors.white),
                                decoration: InputDecoration(
                                    hintText: "Insert your activity",
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(fontFamily: Constants.font, color: Colors.white54),
                                    fillColor: ColorUtils.blue_item),
                              ))
                        ),
                        Text("Focusing",
                            style: TextStyle(
                                fontFamily: Constants.font,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.white)),

                        Text("You should set Focus (F) and Break (B) duration as minute",
                            style: TextStyle(
                                fontFamily: Constants.font,
                                fontSize: 12,
                                color: Colors.white)),

                        Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 20),
                          child: RadioFocus(
                            onSelected: (focus){
                              focussing = focus;
                            },
                          )
                        
                        ),
                        Text("Long Break",
                            style: TextStyle(
                                fontFamily: Constants.font,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.white)),
                        Text("After four cril you should take a long breath",
                          style: TextStyle(
                              fontFamily: Constants.font,
                              fontSize: 12,
                              color: Colors.white)),

                        Padding(
                          padding: EdgeInsets.only(top: 8, bottom: 20),
                          child: GroupTimer(
                            onSelected: (longBreak){
                              longBreakValue = longBreak;
                              print("Long break : "+longBreakValue.toString());
                            },
                          )
                          
                        ),        

                        Text("Notification",
                            style: TextStyle(
                                fontFamily: Constants.font,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.white)),

                        Text("After four cril you should take a long breath",
                          style: TextStyle(
                              fontFamily: Constants.font,
                              fontSize: 12,
                              color: Colors.white)),

                        Container(
                          color: ColorUtils.blue_app,
                          padding: EdgeInsets.only(top: 10, bottom: 20),
                          margin: EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                                Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  child:CRItem(
                                  active: isRinging,
                                  margin: EdgeInsets.only(right: 8),
                                  child: Text("Ring", textAlign: TextAlign.center,style:TextStyle(color:Colors.white, fontSize: 11, fontFamily:Constants.font)),
                                ),
                                onTap: (){
                                  setState(() {
                                    isRinging = !isRinging;
                                  });
                                })
                              ),
                              Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  child:CRItem(
                                    active: isVibrate,
                                    margin: EdgeInsets.only(left: 8),
                                    child: Text("Vibration", textAlign: TextAlign.center,style:TextStyle(color:Colors.white, fontSize: 11, fontFamily:Constants.font)),
                                  ),
                                  onTap: (){
                                    setState(() {
                                      isVibrate = !isVibrate;
                                    });
                                  },
                                ) 
                              )
                            ],
                          ),
                        ),

                        Container(padding: EdgeInsets.only(top: 10, bottom: 10), 
                          child:
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children:<Widget>[
                          CRButton(isWhite: false,
                            text: "Set", onClick: (){
                            if(crilName.isNotEmpty){
                              final setting = Setting(isRinging: isRinging, isVibrate: isVibrate);
                              final data = CrilData(
                                crilName: crilName, 
                                focussing: focussing,
                                longBreak: longBreakValue,
                                targetCrill: sliderValue.toInt(),
                                setting: setting
                              );
                              print("data "+data.crilName+" "+data.focussing.toString()+" long break "+setting.isRinging.toString());
                               Navigator.push(context, SlideTopRoute(
                                page: PomoTracker(
                                  crilData: data,
                                  homeState: widget.homeState,
                                )
                              )); 
                            }
                          })
                          ]
                        )
                       ),
                        
                      ],
                    ),
                  ),
                )
              ]
              ),
        )
    );
            
  }

}
