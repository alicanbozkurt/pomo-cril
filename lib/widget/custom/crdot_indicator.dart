import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pomodoro_apps/utils/color_utils.dart';

class CRDotIndicator extends StatefulWidget{


  static CRDotIndicatorState of(BuildContext context) => context.ancestorStateOfType(const TypeMatcher<CRDotIndicatorState>());

  @override
  State<StatefulWidget> createState() => CRDotIndicatorState();

}

class CRDotIndicatorState extends State<CRDotIndicator>{
  
  var notifierIndex = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
     valueListenable: notifierIndex,
      builder: (context, value, child) {    
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
            color: value == 1? ColorUtils.blue_focus : Colors.transparent
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


    );
  }




}