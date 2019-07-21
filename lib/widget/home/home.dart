import 'package:flutter/material.dart';
import 'package:pomodoro_apps/utils/animation.dart';
import 'package:pomodoro_apps/utils/color_utils.dart';
import 'package:pomodoro_apps/utils/constants.dart';
import 'package:pomodoro_apps/widget/pomo/Pomo.dart';
import 'package:pomodoro_apps/widget/setting/setting.dart';

class Home extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => HomeState();

}

class HomeState extends State<Home>{

  bool isEmpty = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
          child: Column(
            children: <Widget>[
              titleWidget(),
              isEmpty ? emptyCril() : fillCril()
            ],
          )
          
          ,
        
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorUtils.blue_app,
      child: Image.asset(isEmpty ? "assets/img/icon_home_empty.png" : "assets/img/icon_home.png"), onPressed: () {
        if(isEmpty){
          setState(() {
            isEmpty = false;
          });
        }else{
           Navigator.push(context, SlideTopRoute(page: Pomo()));
        }
      }),
      bottomNavigationBar: BottomAppBar(
        notchMargin: 4,
        elevation: 8,
        shape: CircularNotchedRectangle(),
        color: ColorUtils.blue_app,
        child: Container(
          height: 60,
         child:Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(icon: Icon(Icons.home, color: isEmpty ? Colors.transparent: Colors.white, size: 28,), onPressed: () {},),
          Padding(padding:EdgeInsets.only(top: 24),child:Text("Start a Cril", style:TextStyle(color:Colors.white,fontSize: 16,fontFamily: Constants.font))),
          IconButton(icon: !isEmpty? Image.asset("assets/img/icon_home_2.png", width: 26,) :Icon(Icons.home, color: Colors.transparent,) , onPressed: () {},),
        ],
      ),
        )
      ),
    );
  }

  Widget crilList(){
    return Container(
      padding: EdgeInsets.all(10),
      child:Column(children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
             Text("Today", style:TextStyle(fontFamily: Constants.font,fontSize: 18, fontWeight: FontWeight.bold, color:Colors.black)),
             Text("10 Cril", style:TextStyle(fontFamily: Constants.font,fontSize: 18, fontWeight: FontWeight.bold, color:Colors.black)),
             
          ],
        ),
        Padding(
               padding: EdgeInsets.only(top: 10, bottom: 8),
               child: Container(
                 height: 1,
                 color: Colors.black,
               ),
             ),
       itemCrilList("Studying on Math", 5),      
       itemCrilList("Studying on Pyhsics", 5),      
       itemCrilList("Working on new logo", 3),      
    ])
    );
  }

  Widget itemCrilList(String text, int value){
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

  Widget fillCril(){
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: EdgeInsets.all(20),
      child: ListView(
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("your daily cril average is ", style:TextStyle(fontFamily: Constants.font,fontSize: 18, color:Colors.black87)),
              Text("3", style:TextStyle(fontFamily: Constants.font,fontSize: 18, fontWeight: FontWeight.bold, color:ColorUtils.blue_app))
            ],
          ),
          crilList()
        ],
      ),
    );
  }

  Widget emptyCril(){
    return Center(
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
          )

        ],
      ),
      )
    );
  }

  Widget titleWidget(){
    return Container(
      color: ColorUtils.bg_home,
      margin: EdgeInsets.only(top: 24),
      padding: EdgeInsets.only(top: 16, left: 20, right: 20, bottom: 16),
      child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("crillo.",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontFamily: Constants.font)),
              IconButton(icon: Image.asset("assets/img/icon_gear.png", width: 29,), onPressed: (){ 
                 Navigator.push(context, 
                            MaterialPageRoute(builder: (context) => Setting())
                            );
                          
              },)
            ],
          )
    );
  }

}