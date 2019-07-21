import 'package:flutter/material.dart';
import 'package:pomodoro_apps/utils/color_utils.dart';

class CRItem extends StatefulWidget{
  final Widget child;
  final EdgeInsetsGeometry margin;
  final bool active;
  CRItem({this.child, this.margin, this.active});
  @override
  State<StatefulWidget> createState() => CRItemSate();

}

class CRItemSate extends State<CRItem>{
  bool isSelected = false;
  @override
  void initState() {
    super.initState();
    setState(() {
      if(widget.active != null && widget.active)
      isSelected = true;
    });
    
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        setState(() {
          isSelected = !isSelected;
        });
      },
      child:Container(
        margin: widget.margin != null ? widget.margin : EdgeInsets.zero,
        padding: EdgeInsets.only(top:16, bottom: 16, right: 10, left: 10),
          decoration: BoxDecoration(
            color: ColorUtils.blue_item,
            borderRadius: new BorderRadius.all(Radius.circular(8)),
              border: new Border.all(color: isSelected?Colors.white: ColorUtils.blue_item, width: 1),
          ),
          child: widget.child,
        )
    );
  }
    

}