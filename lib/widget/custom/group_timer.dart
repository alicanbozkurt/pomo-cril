import 'package:flutter/material.dart';
import 'package:pomodoro_apps/utils/constants.dart';
import 'package:pomodoro_apps/widget/custom/critem.dart';

class GroupTimer extends StatefulWidget{
  
  final Function onSelected;
  GroupTimer({this.onSelected});

  @override
  State<StatefulWidget> createState() => StateGroupTimer();

}

class StateGroupTimer extends State<GroupTimer>{
  final indexSelected = ValueNotifier(1);
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
     valueListenable: indexSelected,
        builder: (context, value, child) {

     return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        GestureDetector(
          child:CRItem(
              position: 1,
              active: indexSelected.value == 1,
              child: Text("15 Minutes", style:TextStyle(color:Colors.white, fontSize: 11, fontFamily:Constants.font)),
            ),
            onTap: (){
              indexSelected.value = 1;
              widget.onSelected(15);
            },
        ),
         GestureDetector(
          child:
            CRItem(
              position: 2,
              active: indexSelected.value == 2,
              child: Text("30 Minutes", style:TextStyle(color:Colors.white, fontSize: 11,fontFamily:Constants.font)),
            ),
          onTap:(){
            indexSelected.value = 2;
            widget.onSelected(30);
        }),
        GestureDetector(
          child:
            CRItem(
              position: 3,
              active: indexSelected.value == 3,
              child: Text("45 Minutes", style:TextStyle(color:Colors.white,fontSize: 11,  fontFamily:Constants.font)),
            ),
          onTap:(){
            indexSelected.value =3;
            widget.onSelected(45);
          }),
          GestureDetector(
          child:
            CRItem(
              position: 4,
              active: indexSelected.value == 4,
              child: Text("60 Minutes", style:TextStyle(color:Colors.white,fontSize: 11, fontFamily:Constants.font)),
            ),
          onTap: (){
            indexSelected.value = 4;
            widget.onSelected(60);
          }),
        
      ],
     
    );
        });
  }

}