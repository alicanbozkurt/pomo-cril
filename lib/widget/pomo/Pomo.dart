import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pomodoro_apps/utils/animation.dart';
import 'package:pomodoro_apps/utils/color_utils.dart';
import 'package:pomodoro_apps/utils/constants.dart';
import 'package:pomodoro_apps/widget/custom/crbutton.dart';
import 'package:pomodoro_apps/widget/custom/critem.dart';
import 'package:pomodoro_apps/widget/pomo/pomo_tracker.dart';

class Pomo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PomoState();
}

class PomoState extends State<Pomo> {
  double sliderValue = 10;
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center ,
                  children: <Widget>[
                    IconButton(icon: Icon(Icons.arrow_back, color: Colors.white), onPressed: (){
                      Navigator.of(context).pop();
                    }),
                    Expanded(
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
                            style:TextStyle(fontFamily: Constants.font, color: Colors.white),
                            decoration: InputDecoration(
                                hintText: "Crill Name",
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              children:<Widget>[
                              CRItem(
                                  child: Container(
                                    width: 75,
                                    child:Column(children: <Widget>[
                                      Image.asset("assets/img/eye_open.png", width: 25,),
                                      Padding(padding:EdgeInsets.only(top: 16, bottom: 8), child:Text("Relax", style: TextStyle(fontFamily: Constants.font,fontSize: 11, color: Colors.white),))
                                    ])
                                  )
                                ),
                                Padding(padding:EdgeInsets.only(top: 4), child:Text("20F - 10B", style:TextStyle(color:Colors.white, fontFamily:Constants.font, fontSize: 12)))
                              ]
                            ),
                            
                            Column(
                              children:<Widget>[
                              CRItem(
                                  child: Container(
                                    width: 75,
                                    child:Column(children: <Widget>[
                                      Image.asset("assets/img/eye_open_2.png", width: 25,),
                                      Padding(padding:EdgeInsets.only(top: 16, bottom: 8), child:Text("Normal", style: TextStyle(fontFamily: Constants.font,fontSize: 11, color: Colors.white),))
                                    ])
                                  )
                                ),
                                Padding(padding:EdgeInsets.only(top: 4), child:Text("25F - 5B", style:TextStyle(color:Colors.white, fontFamily:Constants.font, fontSize: 12)))
                              ]
                            ),

                            Column(
                              children:<Widget>[
                              CRItem(
                                  child: Container(
                                    width: 75,
                                    child:Column(children: <Widget>[
                                      Image.asset("assets/img/eye_open_3.png", width: 25,),
                                      Padding(padding:EdgeInsets.only(top: 16, bottom: 8), child:Text("No Blingking", style: TextStyle(fontFamily: Constants.font,fontSize: 11, color: Colors.white),))
                                    ])
                                  )
                                ),
                                Padding(padding:EdgeInsets.only(top: 4), child:Text("50F - 10B", style:TextStyle(color:Colors.white, fontFamily:Constants.font, fontSize: 12)))
                              ]
                            )

                          ],
                        ),
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            CRItem(
                              child: Text("15 Minutes", style:TextStyle(color:Colors.white, fontSize: 11, fontFamily:Constants.font)),
                            ),
                            CRItem(
                              child: Text("30 Minutes", style:TextStyle(color:Colors.white, fontSize: 11,fontFamily:Constants.font)),
                            ),
                            CRItem(
                              child: Text("45 Minutes", style:TextStyle(color:Colors.white,fontSize: 11,  fontFamily:Constants.font)),
                            ),
                            CRItem(
                              child: Text("60 Minutes", style:TextStyle(color:Colors.white,fontSize: 11, fontFamily:Constants.font)),
                            ),
                          ],
                        ),
                      ),      

                      Text("Target Crils",
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

                      Padding(padding: EdgeInsets.only(top: 8, bottom: 8 ), child:
                        Slider(
                          activeColor: Colors.white,
                          min: 0,
                          max: 20,
                          onChanged: (newRating){
                            setState(() {
                               setState(() => sliderValue = newRating);
                            });
                          },
                          value: sliderValue,
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

                      Padding(
                        padding: EdgeInsets.only(top: 8, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                              Expanded(
                              flex: 1,
                              child: CRItem(
                                 active: true,
                                margin: EdgeInsets.only(right: 8),
                                child: Text("Ring", textAlign: TextAlign.center,style:TextStyle(color:Colors.white, fontSize: 11, fontFamily:Constants.font)),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: CRItem(
                                active: true,
                                margin: EdgeInsets.only(left: 8),
                                child: Text("Vibration", textAlign: TextAlign.center,style:TextStyle(color:Colors.white, fontSize: 11, fontFamily:Constants.font)),
                              ),
                            )
                          ],
                        ),
                      ),
                       Container(padding: EdgeInsets.only(top: 10, bottom: 10), 
                          child:
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:<Widget>[
                          CRButton(text: "Submit", onClick: (){
                            Navigator.push(context, SlideTopRoute(
                              page: PomoTracker()
                            ));
                          },)
                          ]
                        )
                       )
                    ],
                  ),
                ),
              )
            ])));
  }
}
