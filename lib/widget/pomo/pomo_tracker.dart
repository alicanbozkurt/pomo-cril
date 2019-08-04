import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:pomodoro_apps/model/cril_data.dart';
import 'package:pomodoro_apps/utils/animation.dart';
import 'package:pomodoro_apps/utils/color_utils.dart';
import 'package:pomodoro_apps/utils/constants.dart';
import 'package:pomodoro_apps/utils/notification_helper.dart';
import 'package:pomodoro_apps/widget/custom/back.dart';
import 'package:pomodoro_apps/widget/custom/crbutton.dart';
import 'package:pomodoro_apps/widget/custom/crdialog.dart';
import 'package:pomodoro_apps/widget/custom/crtimer.dart';
import 'package:pomodoro_apps/widget/pomo/pomo.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  CRILLING_COMPLETE, 
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
  int crillingValue = -1;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin; 

  @override
  void initState() {
    super.initState();
    initNotification();
    minutes = DataApp.isForTest ? 1 : getMinusCriling(widget.crilData.focussing);
  }

  @override
  void dispose() {
    if(timer != null)
      timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()  {
        print("back button");
        return stateTracker == StateTracker.OVERTIME || stateTracker == StateTracker.CRILLING_COMPLETE ? Future.value(true) : Future.value(false);
      },
    child:
    Scaffold(
        body: Container(
            margin: EdgeInsets.only(top: 24),
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: <Widget>[
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
                      child:Text(stateTracker == StateTracker.IDLE ? "Start a Cril" : stateTracker == StateTracker.DONE ? "Summary":"Crilling", textAlign: TextAlign.center, style: TextStyle(fontFamily: Constants.font, fontSize: 14, color: Colors.white),)
                    )
                    
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 50),
                child: Container(
                  height: MediaQuery.of(context).size.height - 120,
                  color: ColorUtils.blue_app,
                  child: Center(
                    child:Column(
                      mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding:EdgeInsets.only(bottom: 30),
                        child: stateTracker == StateTracker.DONE ?
                        completeCril():
                        CRTimer(children: <Widget>[
                          Padding(padding:EdgeInsets.only(top: 20, bottom: 10), child: Text(secondMinutesText(minutes)+":"+secondMinutesText(second), style: TextStyle(fontFamily: Constants.font, fontSize: 35, color: Colors.white))),
                          Text(textStatusTitle(), textAlign: TextAlign.center,style: TextStyle(fontFamily: Constants.font, fontSize: 16, color: Colors.white),),
                        ], stateTracker:  stateTracker) 
                      ),
                      dotIndicator(),
                      textCril(),
                      Padding(padding: EdgeInsets.only(bottom: 5), child:Text(getFocussing(widget.crilData.focussing), textAlign: TextAlign.center,style: TextStyle(fontFamily: Constants.font, fontSize: 13, color: Colors.white))),
                      Padding(padding: EdgeInsets.only(bottom: 5), child:Text("Unlimited Session", textAlign: TextAlign.center,style: TextStyle(fontFamily: Constants.font, fontSize: 13, color: Colors.white))),
                      Padding(padding: EdgeInsets.only(bottom: 10), child:Text("Long Break - "+widget.crilData.longBreak.toString()+" minutes", textAlign: TextAlign.center,style: TextStyle(fontFamily: Constants.font, fontSize: 13, color: Colors.white))),
                      buttonControl(),
                    ],
                  ),
                )
                )
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  color: ColorUtils.blue_app,
                  padding: EdgeInsets.only(top:10, bottom: 20), 
                  width: MediaQuery.of(context).size.width,
                  child:
                      stateTracker == StateTracker.OVERTIME || stateTracker == StateTracker.SHORTBREAK || stateTracker == StateTracker.CRILLING_COMPLETE || stateTracker == StateTracker.LONGBREAK
                      ?
                        Stack(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.center,
                              child: CRButton(isWhite:false,text: stateTracker == StateTracker.OVERTIME ? ( crillingValue == widget.crilData.targetCrill - 1 ?  "Long Break" : "Break" ) :   stateTracker == StateTracker.CRILLING_COMPLETE ?  "Focus":  stateTracker == StateTracker.LONGBREAK ? "Start a New Crill": "Focus", onClick: (){ 
                                  // short break overtime
                                  if(stateTracker == StateTracker.OVERTIME){
                                  setState(() {
                                    if(crillingValue == widget.crilData.targetCrill - 1 ){ // long break
                                     setState(() {
                                      stateTracker = StateTracker.LONGBREAK;
                                      minutes = DataApp.isForTest ? 1 : widget.crilData.longBreak;
                                      startTimer(false);
                                      });

                                    }else{ // short break
                                      minutes = DataApp.isForTest ? 1 : getShortBreakCrilling(widget.crilData.focussing);
                                      stateTracker = StateTracker.SHORTBREAK;
                                      playNotification();
                                      startTimer(true);
                                    }
                                  });
                                  }
                                  else if(stateTracker == StateTracker.CRILLING_COMPLETE
                                    || stateTracker == StateTracker.SHORTBREAK){
                                   setState(() =>  stateTracker = StateTracker.CRILLING);
                                    resetValue();
                                    playNotification();
                                    startTimer(true);
                                  }else if(stateTracker == StateTracker.LONGBREAK){
                                    Navigator.push(context, SlideTopRoute(
                                    page: Pomo())); 
                                  }
                                  
                              }),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding:EdgeInsets.only(right: 200, top: 16),
                                child: GestureDetector(
                                child:Text( stateTracker == StateTracker.CRILLING_COMPLETE ? "Done":  (stateTracker == StateTracker.LONGBREAK ? "": "Done"), style:TextStyle(
                                color:Colors.white, fontSize: 14 
                                )
                                ),
                                onTap: (){
                                  if(stateTracker == StateTracker.CRILLING_COMPLETE){
                                    setState(() {
                                     /*  stateTracker = StateTracker.LONGBREAK;
                                      minutes = DataApp.isForTest ? 1 : widget.crilData.longBreak;
                                      startTimer(false); */
                                       setState(() =>  stateTracker = StateTracker.DONE);
                                      });
                                  }else{
                                    setState(() =>  stateTracker = StateTracker.DONE);
                                  }
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
                              CRButton(isWhite:false, text: "Go Home", onClick: (){ 
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                setState(() {
                                  DataApp.isEmpty = false;
                                  Future<SharedPreferences> preff = SharedPreferences.getInstance();
                                  preff.then((pref){
                                    pref.setBool("isEmpty", false);
                                  });
                                });
                              })
                              ]
                            )
                          )
                         : Container(width: 1, height: 1,),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:<Widget>[
                            CRButton(
                              isWhite: false,
                              text: 
                            stateTracker == StateTracker.IDLE?
                            "Start a New Cril"
                            : stateTracker == StateTracker.CRILLING ? "Give Up" :
                            stateTracker == StateTracker.OVERTIME ? "Break" :
                            "Start a New Cril"
                            
                            , onClick: (){
                              setState(() {
                                if(stateTracker == StateTracker.IDLE){
                                  stateTracker = StateTracker.CRILLING;
                                  startTimer(true);
                                  playNotification();
                                }else if(stateTracker == StateTracker.OVERTIME){
                                  stateTracker = StateTracker.DONE;
                                }else if(stateTracker == StateTracker.CRILLING){
                                  // Give Up
                                  stopTimer();
                                  Future.delayed(const Duration(milliseconds: 100), () {
                                    
                                      showDialogNotif();

                                  });
                                 
                                }else{  
                                  //stateTracker = StateTracker.DONE;
                                  Navigator.pushReplacement(context, SlideTopRoute(
                                    page: Pomo())); 
                                }
                              });
                            },)
                            ]
                          ),
                      ])
                      
                      )
              )
            
              ]
            )
      ),
    )
    );
  }

  void initNotification(){
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('launcher_icon');
    var initializationSettingsIOS = new IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) async{

        });
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (data) async{

        });

  }

  void playNotification(){

    showNotification();

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

  void showNotification(){
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'your channel id', 'your channel name', 'your channel description',
    importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
    androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    print("notification play ");
    final titleNotif = stateTracker == StateTracker.CRILLING ?
    "You're focused ("+(crillingValue +1 == 0 ? 1 : crillingValue +1).toString()+"/4)." :
    stateTracker == StateTracker.OVERTIME ? "It's time to break!" :
    stateTracker == StateTracker.SHORTBREAK ? "Break Time" :
    "Crill Cycle is done!";

    final descNotif = stateTracker == StateTracker.CRILLING ?
    getMinusCriling(widget.crilData.focussing).toString()+":00":
    stateTracker == StateTracker.OVERTIME ? "You should give a break after a Crill." :
    stateTracker == StateTracker.CRILLING_COMPLETE ? getShortBreakCrilling(widget.crilData.focussing).toString()+":00":
    "If you are going to start a new serie you should give a long break.";

    showIconNotification(context, flutterLocalNotificationsPlugin, title: titleNotif, body: descNotif, icon:'assets/img/ic_notif.png', id: 2);

  }

  String textStatusTitle(){
    return stateTracker == StateTracker.IDLE ? "Ready" : stateTracker == StateTracker.CRILLING ? "Focus" :
    stateTracker == StateTracker.OVERTIME ? "Overtime" : stateTracker == StateTracker.SHORTBREAK ? "Short Break" :
    stateTracker == StateTracker.CRILLING_COMPLETE ? "Short Break": "Long Break";
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

  int getShortBreakCrilling(Focussing focussing){
    return focussing == Focussing.Relax ? 10 : focussing == Focussing.Normal ? 5 : 10;
  }

  void showDialogNotif(){
    showDialog(
      context: context, 
      builder: (BuildContext context) => CRDialog(
        imgTitle: "assets/img/ic_notif.png",
        title: "You're about to give up",
        description: "If you give up on this Crill, it won't be \ncounted as done. Are you sure to give up?",
        buttonDialog: ButtonDialog(
          titleAccept: "Continue Crill",
          titleDecline: "Give Up",
        ),
        onAccept: (){
            startTimer(false);
          },
          onDecline: (){
            print("decline");
            setState(() {
              stateTracker = StateTracker.DONE;
            });
          }
      )
    );
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
          Text((crillingValue + 1).toString(), textAlign: TextAlign.center,style: TextStyle(fontFamily: Constants.font, fontSize: 100, color: Colors.white),),
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
    minutes = DataApp.isForTest ? 1 : (widget.crilData.focussing);
  }

  void startTimer(bool isFromStart){
   
   if(isFromStart)
    startValue();

    const onceSecond = Duration(seconds: 1);
    timer = Timer.periodic(onceSecond, (Timer timer) => setState(
      () {
        if (minutes < 1 && second < 1) {
          setState(() {
            if(stateTracker == StateTracker.CRILLING){
              stateTracker = StateTracker.OVERTIME;
              crillingValue++;
            }else if(stateTracker == StateTracker.LONGBREAK)
              stateTracker = StateTracker.DONE;
            else
              stateTracker = StateTracker.CRILLING_COMPLETE;
              
          });
          playNotification();
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

  List<Widget> getDotFocussIndicator(){
    List<Widget> listWidget = List();
   var target = widget.crilData.targetCrill;
   target = target == 0 ? 1 : target;
    for(int i=0; i < target; i++){
      var widget = Padding(padding: EdgeInsets.only(right: 10),
            child:Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: stateTracker == StateTracker.CRILLING && crillingValue == i-1 ||  crillingValue == i ? ColorUtils.blue_focus : crillingValue > i ? ColorUtils.blue_focus : Colors.white, width: 2),
                color: crillingValue > i || crillingValue == i ? ColorUtils.blue_focus  : Colors.transparent
              ),
            )
        );
        listWidget.add(widget);
    }
    return listWidget;
  }

  Widget dotIndicator(){
    return Container(
      width: 120,
      child:Column(
        children:<Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: getDotFocussIndicator()
        ),
        stateTracker == StateTracker.SHORTBREAK || stateTracker == StateTracker.LONGBREAK?
        Align(
          alignment: Alignment.bottomLeft,
          child:Container(
            margin: EdgeInsets.only(left: stateTracker == StateTracker.LONGBREAK ? 4 : 16 + (30 * crillingValue).toDouble() , top: 8),
                width: stateTracker == StateTracker.LONGBREAK ? 100 : 15,
                height: 2,
                color: Colors.white,
              )
          )
          :
          Container(height: 1)
        ]
      )
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
          icon: Image.asset("assets/img/icon_ringer.png", color: widget.crilData.setting.isRinging ? ColorUtils.blue_focus : Colors.white, width: 20, height: 20,),
          onPressed: (){},
        ),
        IconButton(
          icon: Image.asset("assets/img/icon_vibrate.png", color: widget.crilData.setting.isVibrate ? ColorUtils.blue_focus : Colors.white, width: 20, height: 20,),
          onPressed: (){},
        ),
      ],
    );
  }
}