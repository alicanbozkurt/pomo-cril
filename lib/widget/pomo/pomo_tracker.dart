import 'package:flutter/material.dart';
import 'package:pomodoro_apps/model/cril_data.dart';
import 'package:pomodoro_apps/utils/color_utils.dart';
import 'package:pomodoro_apps/utils/constants.dart';
import 'package:pomodoro_apps/widget/custom/back.dart';
import 'package:pomodoro_apps/widget/custom/crbutton.dart';
import 'package:pomodoro_apps/widget/custom/crtimer.dart';

class PomoTracker extends StatefulWidget{
  final CrilData crilData;
  PomoTracker({this.crilData});
  @override
  State<StatefulWidget> createState() => PomoTrackerState();

}

enum StateTracker{
  START,
  CRIL, 
  IDLE,
  COMPLETE
}

class PomoTrackerState extends State<PomoTracker>{
  StateTracker stateTracker = StateTracker.IDLE;
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
                        child: stateTracker == StateTracker.COMPLETE ?
                        completeCril():
                        CRTimer(children: <Widget>[
                          Padding(padding:EdgeInsets.only(top: 20, bottom: 10), child: Text("20:00", style: TextStyle(fontFamily: Constants.font, fontSize: 35, color: Colors.white))),
                          Text(stateTracker == StateTracker.IDLE ? "Ready" : "Focus", style: TextStyle(fontFamily: Constants.font, fontSize: 16, color: Colors.white),),
                        ], stateTracker:  stateTracker) 
                      ),
                      dotIndicator(),
                      textCril(),
                      Padding(padding: EdgeInsets.only(bottom: 5), child:Text(getFocussing(widget.crilData.focussing), textAlign: TextAlign.center,style: TextStyle(fontFamily: Constants.font, fontSize: 13, color: Colors.white))),
                      Padding(padding: EdgeInsets.only(bottom: 5), child:Text("Unlimited Session", textAlign: TextAlign.center,style: TextStyle(fontFamily: Constants.font, fontSize: 13, color: Colors.white))),
                      Padding(padding: EdgeInsets.only(bottom: 10), child:Text("Long Break - 15 Minutes", textAlign: TextAlign.center,style: TextStyle(fontFamily: Constants.font, fontSize: 13, color: Colors.white))),
                      buttonControl(),
                      Padding(padding: EdgeInsets.only(top:20, bottom: 5), child: 
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          stateTracker == StateTracker.COMPLETE?
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
                            : stateTracker == StateTracker.CRIL ? "Break" :
                            stateTracker == StateTracker.COMPLETE ? "Done" :
                            "Give Up"
                            
                            , onClick: (){
                              setState(() {
                                if(stateTracker == StateTracker.IDLE){
                                  stateTracker = StateTracker.START;
                                }else if(stateTracker == StateTracker.START){
                                  stateTracker = StateTracker.CRIL;
                                }else{
                                  stateTracker = StateTracker.COMPLETE;
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

  String getFocussing(Focussing focussing){
    return focussing == Focussing.Normal ? "Normal" : focussing == Focussing.Relax ? "Relax" : "No Blinking";

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