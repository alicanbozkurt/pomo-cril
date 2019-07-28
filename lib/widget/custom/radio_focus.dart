import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pomodoro_apps/model/cril_data.dart';
import 'package:pomodoro_apps/utils/constants.dart';

import 'critem.dart';

class FocusData {
  final String icon;
  final String title;
  final String desc;
  bool isSelected;
  FocusData({this.icon, this.desc, this.title, this.isSelected});
}

class RadioFocus extends StatefulWidget {
  final Function onSelected;
  RadioFocus({this.onSelected});
  
  @override
  State<StatefulWidget> createState() => RadioFocusState();
}

class RadioFocusState extends State<RadioFocus> {

  final listData = [
                      FocusData(icon:"assets/img/eye_open.png", title: "Relax", desc: "20F - 10B"),
                      FocusData(icon:"assets/img/eye_open_2.png", title: "Normal", desc: "25F - 5B"),
                      FocusData(icon:"assets/img/eye_open_3.png", title: "No Blingking", desc: "50F - 10B"),
                    ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
     final isActiveTrigger = ValueNotifier(0);
    return ValueListenableBuilder<int>(
     valueListenable: isActiveTrigger,
        builder: (context, value, child) {

     return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        GestureDetector(
          child: FocusItem(
            focusData: listData[0],
            position: 0,
            isActive: isActiveTrigger.value == 0,
          ),
          onTap: (){
            isActiveTrigger.value = 0;
            widget.onSelected(Focussing.Relax);
          },
        ),
         GestureDetector(
          child: FocusItem(
            focusData: listData[1],
            position: 1,
            isActive: isActiveTrigger.value == 1,
          ),
          onTap: (){
            isActiveTrigger.value = 1;
             widget.onSelected(Focussing.Normal);
          }
        ),
         GestureDetector(
          child: FocusItem(
            focusData: listData[2],
            position: 2,
            isActive: isActiveTrigger.value == 2,
          ),
          onTap: (){
            isActiveTrigger.value = 2;
             widget.onSelected(Focussing.NoBlinking);
          }
        ),

        ],
      );
    }
    );
    
  }

  void onSelected(int position) {
    print("position " + position.toString());
  }


}

class FocusItem extends StatefulWidget{
  final FocusData focusData;
  final int position;
  final bool isActive;

  FocusItem({this.focusData, this.position, this.isActive});

  @override
  State<StatefulWidget> createState() => FocusItemState();
  
}

class FocusItemState extends State<FocusItem>{


  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CRItem(
              child: Container(
                width: 75,
                child:Column(children: <Widget>[
                  Image.asset(widget.focusData.icon, width: 25,),
                  Padding(padding:EdgeInsets.only(top: 16, bottom: 8), child:Text(
                    widget.focusData.title,  
                    style: TextStyle(fontFamily: Constants.font,fontSize: 11, color: Colors.white),))
                ])
              ),
              position: widget.position,
              active: widget.isActive,
                ),
        Padding(padding:EdgeInsets.only(top: 4), child:Text( widget.focusData.desc,
                 style:TextStyle(color:Colors.white, fontFamily:Constants.font, fontSize: 12)))
      ],
    );
  }


}
