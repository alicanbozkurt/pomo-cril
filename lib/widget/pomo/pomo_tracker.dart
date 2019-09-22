import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:local_notifications/local_notifications.dart';
import 'package:pomodoro_apps/model/cril_data.dart';
import 'package:pomodoro_apps/model/crill_model.dart';
import 'package:pomodoro_apps/utils/animation.dart';
import 'package:pomodoro_apps/utils/color_utils.dart';
import 'package:pomodoro_apps/utils/constants.dart';
import 'package:pomodoro_apps/utils/db_helper.dart';
import 'package:pomodoro_apps/widget/custom/back.dart';
import 'package:pomodoro_apps/widget/custom/crbutton.dart';
import 'package:pomodoro_apps/widget/custom/crdialog.dart';
import 'package:pomodoro_apps/widget/custom/crtimer.dart';
import 'package:pomodoro_apps/widget/home/home.dart';
import 'package:pomodoro_apps/utils/notification_helper.dart';
import 'package:pomodoro_apps/widget/pomo/pomo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

class PomoTracker extends StatefulWidget{
  final CrilData crilData;
  final HomeState homeState;
  PomoTracker({Key key, this.crilData, this.homeState}) : super(key: key);
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

class PomoTrackerState extends State<PomoTracker> with WidgetsBindingObserver{
  StateTracker stateTracker = StateTracker.IDLE;
  int minutes = 0;
  int second = 0;
  int crillingValue = -1;

  static const MethodChannel platform =
      MethodChannel('com.example.pomodoro_apps/service');
  bool _connectedToService = false;
  int _currentSeconds = 0;
  Timer _timer;
  bool _started = false;

  NotificationHelper notificationHelper = NotificationHelper();

  @override
  void initState() {
    super.initState();
    notificationHelper.init();
    minutes = DataApp.isForTest ? 1 : getMinusCriling(widget.crilData.focussing);
    minutes = minutes * 60;
    _currentSeconds = minutes;

    WidgetsBinding.instance.addObserver(this);
    connectToService();
  }

  @override
  void dispose() {
    if(_timer != null)
      _timer.cancel();
    super.dispose();
  }

  String formatTime(int total) {
    final int minutes = (total / 60).floor();
    final int seconds = total - minutes * 60;
    
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }


  Future<void> connectToService() async {
    try {
      await platform.invokeMethod<void>('connect');
      print('Connected to service');
      /* Scaffold.of(context).showSnackBar(const SnackBar(
          content: Text('Connected to app service'),
          duration: Duration(seconds: 2))); */
    } on Exception catch (e) {
      print(e.toString());
      Scaffold.of(context).showSnackBar(
          const SnackBar(content: Text('Could not connect to app service.')));
      return;
    }

      try {
        final int serviceCurrentSeconds = await getServiceCurrentSeconds();
     
          _connectedToService = true;

          if (serviceCurrentSeconds <= 0) {
            _currentSeconds = minutes;
            _started = false;
            _timer?.cancel();
          } else {
            _currentSeconds = serviceCurrentSeconds;
            _started = true;
            const Duration oneSecond = Duration(seconds: 1);
            _timer =
                Timer.periodic(oneSecond, (Timer timer) => setState(updateTimer));
          }
        
      } on PlatformException catch (e) {
        print(e.toString());
      } on Exception catch (e) {
        print(e.toString());
      }
    
  }

  void updateTimer() {
    if (_currentSeconds == 1) {
      _timer.cancel();
     
      _started = false;

      setState(() {
            if(stateTracker == StateTracker.CRILLING){
              stateTracker = StateTracker.OVERTIME;
              crillingValue++;
            }else if(stateTracker == StateTracker.LONGBREAK){
              doneState();
            }else
              stateTracker = StateTracker.CRILLING_COMPLETE;
              
          });
      playNotification();
      _currentSeconds = 0;

      stopTimer(false);
    }
    else {
      _currentSeconds--;
    }

   
  }

  doneState(){
    stateTracker = StateTracker.DONE;
    saveCrill();
  }


  Future<void> startServiceTimer(int duration) async {

    try {
      await platform
          .invokeMethod<void>('start', <String, int>{'duration': duration});
    } on PlatformException catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> stopServiceTimer() async {

    try {
      await platform.invokeMethod<void>('stop');
    } on Exception catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<int> getServiceCurrentSeconds() async {
    try {
      final int result = await platform.invokeMethod<int>('getCurrentSeconds');
      return result;
    } on PlatformException catch (e) {
      print(e.toString());
    }

    return 0;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print("stata app :"+state.toString());
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.suspending) {
      _timer?.cancel();
    } else if (state == AppLifecycleState.resumed) {
      connectToService();
    }
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
                          Padding(padding:EdgeInsets.only(top: 20, bottom: 10), child: Text(formatTime(_currentSeconds), style: TextStyle(fontFamily: Constants.font, fontSize: 35, color: Colors.white))),
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
                                      _currentSeconds = minutes * 60;
                                      startTimer(false);
                                      });

                                    }else{ // short break
                                     shortBreak();
                                    }
                                  });
                                  }
                                  else if(stateTracker == StateTracker.CRILLING_COMPLETE
                                    || stateTracker == StateTracker.SHORTBREAK){
                                   setState(() =>  stateTracker = StateTracker.CRILLING);
                                    print("fokus now ");
                                    stopTimer(false);  
                                    Future.delayed(Duration(milliseconds: 500),(){
                                      resetValue();
                                      playNotification();
                                      startTimer(true);
                                    });

                                    
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
                                       setState(() =>  stateTracker = StateTracker.DONE);
                                       saveCrill();
                                      });
                                  }else{
                                    setState(() =>  stateTracker = StateTracker.DONE);
                                    saveCrill();
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
                                  doneState();
                                }else if(stateTracker == StateTracker.CRILLING){
                                  // Give Up
                                  _giveUp();
                                 
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

  _giveUp(){
      stopTimer(true);
      Future.delayed(const Duration(milliseconds: 100), () {
          showDialogNotif();
      });
  }

  shortBreak(){
    minutes = DataApp.isForTest ? 1 : getShortBreakCrilling(widget.crilData.focussing);
    _currentSeconds = minutes * 60;
    stateTracker = StateTracker.SHORTBREAK;
    playNotification();
    startTimer(true);
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
   

    print("notification play ");
    final titleNotif = stateTracker == StateTracker.CRILLING ?
    "You're focused ("+(crillingValue + 2).toString()+"/4)." :
    stateTracker == StateTracker.OVERTIME ? "It's time to break!" :
    stateTracker == StateTracker.SHORTBREAK ? "Break Time" :
    "Crill Cycle is done!";

    final descNotif = stateTracker == StateTracker.CRILLING ?
    getMinusCriling(widget.crilData.focussing).toString()+":00":
    stateTracker == StateTracker.OVERTIME ? "You should give a break after a Crill." :
    stateTracker == StateTracker.CRILLING_COMPLETE ? getShortBreakCrilling(widget.crilData.focussing).toString()+":00":
    "If you are going to start a new serie you should give a long break.";

    final action = stateTracker == StateTracker.CRILLING ? [
       NotificationAction(
            actionText: "Give Up",
            callbackName: "clickGiveUp",
            callback: (data){
              print("give up button");
              _giveUp();
            },
            payload: "giveup",
            launchesApp: true
        ),
    ] : stateTracker == StateTracker.OVERTIME ?
      crillingValue >= 5  ?
      [
        NotificationAction(
            actionText: "Long Break",
             callbackName: "clickLong",
            callback: (data){
                print("click long break");
            },
            payload: "longbreak",
            launchesApp: true
        ),
       NotificationAction(
            actionText: "Done",
            callbackName: "clickDone",
            callback: (data){
              print("click done");
              setState(()=>doneState());
            },
            payload: "done",
            launchesApp: true
        )
      ]
      :
     [
      NotificationAction(
            actionText: "Break Now",
             callbackName: "clickBreak",
            callback: (data){
                print("click disini "+data.toString());
                setState(() {
                  shortBreak();
                });
            },
            payload: "breaknow",
            launchesApp: true
        ),

        NotificationAction(
            actionText: "Done",
             callbackName: "clickDone",
            callback: (data){
              print("click done");
              setState(()=>doneState());
            },
            payload: "done",
            launchesApp: true
        )
    ] : stateTracker == StateTracker.SHORTBREAK ? [
      NotificationAction(
            actionText: "Focus Now",
             callbackName: "clickFocus",
            callback: (data){
              print("click focus");

               stopTimer(false);  
               Future.delayed(Duration(milliseconds: 500),(){
                resetValue();
                playNotification();
                startTimer(true);
              });

            },
            payload: "focusnow",
            launchesApp: true
        ),

        NotificationAction(
            actionText: "Done",
             callbackName: "clickDone",
            callback: (data){
              print("click done");
              setState(()=>doneState());
            },
            payload: "done",
            launchesApp: true
        )
    ] : [

      NotificationAction(
            actionText: "Focus Now",
             callbackName: "clickFocus",
            callback: (data){
              print("click focus");

               stopTimer(false);  
               Future.delayed(Duration(milliseconds: 500),(){
                resetValue();
                playNotification();
                startTimer(true);
              });

            },
            payload: "focusnow",
            launchesApp: true
        ),
     
       NotificationAction(
            actionText: "Done",
            callbackName: "clickDone",
            callback: (data){
              print("click done");
              setState(()=>doneState());
            },
            payload: "done",
            launchesApp: true
        )
    ];

    notificationHelper.showNotification(titleNotif, descNotif,
    action
    );

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
              doneState();
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
    minutes = DataApp.isForTest ? 1 : getMinusCriling(widget.crilData.focussing);
    _currentSeconds = minutes * 60;
  }

  void startTimer(bool isFromStart){
   
   if(isFromStart){
    startValue();
   }
    startServiceTimer(minutes).then((void _) => setState((){
      
       const Duration oneSecond = Duration(seconds: 1);
     
      _timer =  Timer.periodic(oneSecond, (Timer timer) => setState(updateTimer));
            _currentSeconds--;
            if(isFromStart)
            minutes = _currentSeconds;
            _started = true;
      
    }));
   

    /* const onceSecond = Duration(seconds: 1);
    timer = Timer.periodic(onceSecond, (Timer timer) => setState(
      () {
        if (minutes < 1 && second < 1) {
          setState(() {
            if(stateTracker == StateTracker.CRILLING){
              stateTracker = StateTracker.OVERTIME;
              crillingValue++;
            }else if(stateTracker == StateTracker.LONGBREAK){
              stateTracker = StateTracker.DONE;
              saveCrill();
            }else
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
    )); */
  }

  void stopTimer(bool pause){
     stopServiceTimer().then((void _){
        setState(() {
            _timer.cancel();
            _started = false;
            if(!pause)
            _currentSeconds = 0;
          });
        } 
      );
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

  void saveCrill(){
    final date =  DateTime.now().millisecondsSinceEpoch;
    final crill = CrillModel(crillName: widget.crilData.crilName, crilCount: crillingValue + 1, date:date);
    final db = DBHelper();
    
    db.saveCrill(crill);
    print("Save crill ");

    db.getCrillsToday();
    setState(() {
      DataApp.isEmpty = false;
      widget.homeState.getData();
    });
  }
}