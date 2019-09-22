import 'package:flutter/material.dart';
import 'package:pomodoro_apps/model/crill_model.dart';
import 'package:pomodoro_apps/utils/color_utils.dart';
import 'package:pomodoro_apps/utils/constants.dart';

class ItemList extends StatelessWidget{
  final String text;
  final int value;
  ItemList({this.text, this.value});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only( top: 5, bottom: 5),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: ColorUtils.blue_app,
        borderRadius: BorderRadius.all(Radius.circular(4))
      ),
      child:Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:<Widget>[
        Text(text, style:TextStyle(fontFamily: Constants.font,fontSize: 14, color:Colors.white)),
        Text(value.toString()+" Cril", style:TextStyle(fontFamily: Constants.font,fontSize: 14, color:Colors.white)),
        ]
      )
    );
  }

}

class CrillList extends StatelessWidget{
  final List<CrillModel> listData;
  CrillList({this.listData});


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child:Column(children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
             Text("Today", style:TextStyle(fontFamily: Constants.font,fontSize: 18, fontWeight: FontWeight.bold, color:Colors.black)),
             Text(allToday().toString()+" Cril", style:TextStyle(fontFamily: Constants.font,fontSize: 18, fontWeight: FontWeight.bold, color:Colors.black)),
             
          ],
        ),
        Padding(
               padding: EdgeInsets.only(top: 10, bottom: 8),
               child: Container(
                 height: 1,
                 color: Colors.black,
               ),
             ),
        Column(
          children: generateList()
        )     
      ])
    );
  
  }

  int allToday(){
    int allCount = 0;
    listData.forEach((data) => allCount+= data.crilCount);
    return allCount;
  }

  List<Widget> generateList(){
    List<Widget> listWidget = List();
    listData.forEach((data) => listWidget.add(ItemList(text: data.crillName, value: data.crilCount)));
    return listWidget;
  }

}