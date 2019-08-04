import 'package:flutter/material.dart';

class SliderTarget extends StatefulWidget{
  final Function getValue;
  SliderTarget({this.getValue});

  @override
  State<StatefulWidget> createState() => SliderTargetState();

}

class SliderTargetState extends State<SliderTarget>{
  double sliderValue = 4;
  String strSlider = "4";
  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.only(top: 8, bottom: 10 ), child:
            Stack(
              children:<Widget>[
              Slider(
                activeColor: Colors.white,
                min: 0,
                max: 4,
                onChanged: (newRating){
                  strSlider = newRating.toInt() == 0 ? "Free" : newRating.toInt().toString();
                  
                  setState(() {
                    sliderValue = newRating;
                    widget.getValue(newRating);
                  });
                },
                value: sliderValue,
              ),
                Padding(padding: EdgeInsets.only(top: 40), child:
                  Text(strSlider, style: TextStyle(color: Colors.white),)
                )
              ]
            )
      );
  }



  
}