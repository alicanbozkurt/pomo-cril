import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:pomodoro_apps/model/cril_data.dart';
import 'package:pomodoro_apps/utils/color_utils.dart';
import 'package:pomodoro_apps/utils/constants.dart';
import 'package:pomodoro_apps/widget/custom/back.dart';
import 'package:pomodoro_apps/widget/custom/crbutton.dart';
import 'package:pomodoro_apps/widget/custom/crtimer.dart';
import 'package:vibration/vibration.dart';

class PomoTracker extends StatefulWidget{
  final CrilData crilData;
  PomoTracker({this.crilData});
  @override
  State<StatefulWidget> createState() => PomoTrackerState();

}

enum StateTracker{
  IDLE,
  CRILLING, 
  OVERTIME,
  SHORTBREAK,
  LONGBREAK,
  DONE
}

class PomoTrackerState extends State<PomoTracker>{
  StateTracker stateTracker = StateTracker.IDLE;
  int minutes = 0;
  int second = 0;
  Timer timer;

  @override
  void initState() {
    super.initState();
    minutes = 1;//getMinusCriling(widget.crilData.focussing);
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            margin: EdgeInsets.only(top: 24),
            height: MediaQuery.of(context).size.height,
            child: Column(children: <Widget>[
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
                    stateTracker == StateTracker.IDLE ? 
                    Back(isWhite: true,)
                    : Container(
                      width: 1,
                      height: 1,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child:Text(stateTracker == StateTracker.IDLE ? "Start a Cril" : "Cril", textAlign: TextAlign.center, style: TextStyle(fontFamily: Constants.font, fontSize: 14, color: Colors.white),)
                    )
                    
                  ],
                ),
              ),
              Flexible(
                child: Container(
                  color: ColorUtils.blue_app,
                  child: ListView(
                    children: <Widget>[
                      Padding(
                        padding:EdgeInsets.only(top: 30, bottom: 30),
                        child: stateTracker == StateTracker.DONE ?
                        completeCril():
                        CRTimer(children: <Widget>[
                          Padding(padding:EdgeInsets.only(top: 20, bottom: 10), child: Text(secondMinutesText(minutes)+":"+secondMinutesText(second), style: TextStyle(fontFamily: Constants.font, fontSize: 35, color: Colors.white))),
                          Text(textStatusTitle(), style: TextStyle(fontFamily: Constants.font, fontSize: 16, color: Colors.white),),
                        ], stateTracker:  stateTracker) 
                      ),
                      dotIndicator(),
                      textCril(),
                      Padding(padding: EdgeInsets.only(bottom: 5), child:Text(getFocussing(widget.crilData.focussing), textAlign: TextAlign.center,style: TextStyle(fontFamily: Constants.font, fontSize: 13, color: Colors.white))),
                      Padding(padding: EdgeInsets.only(bottom: 5), child:Text("Unlimited Session", textAlign: TextAlign.center,style: TextStyle(fontFamily: Constants.font, fontSize: 13, color: Colors.white))),
                      Padding(padding: EdgeInsets.only(bottom: 10), child:Text("Long Break - "+widget.crilData.longBreak.toString()+" minutes", textAlign: TextAlign.center,style: TextStyle(fontFamily: Constants.font, fontSize: 13, color: Colors.white))),
                      buttonControl(),
                      Padding(padding: EdgeInsets.only(top:20, bottom: 5), child:
                      stateTracker == StateTracker.OVERTIME?
                        Stack(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.center,
                              child: CRButton(text: "Break", onClick: (){ 
                                //Navigator.of(context).pop();
                              }),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding:EdgeInsets.only(right: 200, top: 16),
                                child: GestureDetector(
                                child:Text("Done", style:TextStyle(
                                color:Colors.white, fontSize: 14 
                                )
                                ),
                                onTap: (){
                                  setState(() =>  stateTracker = StateTracker.DONE);
                                },
                              )
                              ),
                            ),
                          ],
                        )
                      : 
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          stateTracker == StateTracker.DONE?
                          Padding(
                            padding: EdgeInsets.only(right: 8),
                            child:Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:<Widget>[
                              CRButton(text: "Go To Dashbord", onClick: (){ 
                                Navigator.of(context).pop();
                              })
                              ]
                            )
                          )
                         : Container(width: 1, height: 1,),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:<Widget>[
                            CRButton(text: 
                            stateTracker == StateTracker.IDLE?
                            "Start a New Cril"
                            : stateTracker == StateTracker.CRILLING ? "Give Up" :
                            stateTracker == StateTracker.OVERTIME ? "Break" :
                            "Done"
                            
                            , onClick: (){
                              setState(() {
                                if(stateTracker == StateTracker.IDLE){
                                  stateTracker = StateTracker.CRILLING;
                                  startTimer(true);
                                }else if(stateTracker == StateTracker.OVERTIME){
                                  stateTracker = StateTracker.DONE;
                                }else{
                                  stateTracker = StateTracker.DONE;
                                }
                              });
                            },)
                            ]
                          ),
                      ])
                      
                      )
                    ],
                  ),
                )
              )
            
              ]
            )
      ),
    );
  }

  void playNotification(){
    if(widget.crilData.setting.isRinging){
     FlutterRingtonePlayer.play(
  android: AndroidSounds.notification,
  ios: IosSounds.glass,
  looping: false,
  volume: 0.1,
);
    }
    if(widget.crilData.setting.isVibrate){

      Vibration.hasVibrator().then((isVibrate) =>  Vibration.vibrate());
      
    }
  }

  String textStatusTitle(){
    return stateTracker == StateTracker.IDLE ? "Ready" : stateTracker == StateTracker.CRILLING ? "Focus" : "Overtime";
  }

  String secondMinutesText(int time){
    return (time < 10 && time > 0 ? "0"+time.toString(): time == 0 ? time.toString()+"0" : time.toString());
  }

  String getFocussing(Focussing focussing){
    return focussing == Focussing.Normal ? "Normal" : focussing == Focussing.Relax ? "Relax" : "No Blinking";

  }

  int getMinusCriling(Focussing focussing){
    return focussing == Focussing.Relax ? 20 : focussing == Focussing.Normal ? 25 : 50;

  }

  Widget completeCril(){
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child:Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("You've completed", textAlign: TextAlign.center,style: TextStyle(fontFamily: Constants.font, fontSize: 26, color: Colors.white),),
        Row(
          mainAxisSize: MainAxisSize.min,
          children:<Widget>[
          Text("4", textAlign: TextAlign.center,style: TextStyle(fontFamily: Constants.font, fontSize: 100, color: Colors.white),),
           Text("cril", textAlign: TextAlign.center,style: TextStyle(fontFamily: Constants.font, fontSize: 26, color: Colors.white),),
          ]
        )
      ],
      )
    );
  }

  void startValue(){
    second = 59;
    minutes--;
  }

  void resetValue(){
    second = 0;
    minutes = getMinusCriling(widget.crilData.focussing);
  }

  void startTimer(bool isFromStart){
   
   if(isFromStart)
    startValue();

    const onceSecond = Duration(seconds: 1);
    timer = Timer.periodic(onceSecond, (Timer timer) => setState(
      () {
        if (minutes < 1 && second < 1) {
          playNotification();
          setState(() {
            stateTracker = StateTracker.OVERTIME;
          });
          timer.cancel();
        }else if(second < 1){ 
          second=59;
          minutes--;
        }else {
          second--;
          print("minutes "+minutes.toString());
        }
      },
    ));
  }

  void stopTimer(){
    timer.cancel();
  }

  Widget dotIndicator(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        
        Padding(padding: EdgeInsets.only(right: 10),
        child:Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
        )
        ),
        Padding(padding: EdgeInsets.only(right: 10),
        child:Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
        )
        ),
        Padding(padding: EdgeInsets.only(right: 10),
        child:Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
        )
        ),
        Padding(padding: EdgeInsets.only(right: 10),
        child:Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
        )
        )

        
        
      ],
    );
  }

  Widget textCril(){
    return Padding(
      padding: EdgeInsets.only(top: 30, bottom: 20),
      child: Text(widget.crilData.crilName, textAlign: TextAlign.center,style: TextStyle(fontFamily: Constants.font, fontSize: 18, color: Colors.white),),
    );
  }

  Widget buttonControl(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Image.asset("assets/img/icon_ringer.png", width: 20, height: 20,),
          onPressed: (){},
        ),
        IconButton(
          icon: Image.asset("assets/img/icon_vibrate.png", width: 20, height: 20,),
          onPressed: (){},
        ),
      ],
    );
  }
}