import 'package:flutter/material.dart';
import 'package:pomodoro_apps/model/crill_model.dart';
import 'package:pomodoro_apps/utils/color_utils.dart';
import 'package:pomodoro_apps/utils/constants.dart';
import 'package:pomodoro_apps/widget/home/dashbord.dart';
import 'package:pomodoro_apps/widget/home/item_list.dart';

class FillCrill extends StatefulWidget{
  final bool isEmpty;
  final List<CrillModel> listData;

  FillCrill({this.isEmpty, this.listData});

  @override
  State<StatefulWidget> createState() => FillCrillState();

}

class FillCrillState extends State<FillCrill>{

  
  @override
  void initState() {
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
      return widget.isEmpty? emptyCril(): Container(
        padding: EdgeInsets.only(left:20, right: 20, bottom: 20, top: 65),
        child: ListView(
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("your daily cril average is ", style:TextStyle(fontFamily: Constants.font,fontSize: 18, color:Colors.black87)),
                Text(widget.listData.length.toString(), style:TextStyle(fontFamily: Constants.font,fontSize: 18, fontWeight: FontWeight.bold, color:ColorUtils.blue_app))
              ],
            ),
            CrillList(listData: widget.listData),
            ChartWidget()
          ],
        ),
      );
    
      
  }

  Widget emptyCril(){
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        child:Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset("assets/img/empty_icon.png", height: 150,),
          Padding(
            padding: EdgeInsets.only(top: 16),
            child: Text("There isn't any cril here.",  style: TextStyle(fontFamily: Constants.font, fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black),),
          ),
           Padding(
            padding: EdgeInsets.only(top: 4),
            child: Text("to focus on your work start a cril", style: TextStyle(fontFamily: Constants.font, fontSize: 20, color: Colors.black),),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: Image.asset("assets/img/arrow.png", width: 19,),
          )

        ],
      ),
      )
    );
  }

}