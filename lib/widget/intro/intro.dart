import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pomodoro_apps/utils/color_utils.dart';
import 'package:pomodoro_apps/utils/constants.dart';
import 'package:pomodoro_apps/widget/home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Intro extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => IntroState();
}

class ItemPage {
  final String icon;
  final String title;
  final String description;
  ItemPage({this.icon, this.title, this.description});
}

class IntroState extends State<Intro> {
  final PageController pageController = PageController();
  bool disableBack = true;
  bool disableSkip = false;
  String textStart = "Next";
  int currentPage = 0;
  Future<SharedPreferences> preff;

  List<ItemPage> listPage = [
    ItemPage(
        icon: "assets/img/logo.png",
        title: "Here to you be productive",
        description: "Lorem Ipsum"),
    ItemPage(
        icon: "assets/img/symbol_11_1.png",
        title: "Customize your Cril",
        description: "Lorem Ipsum"),
    ItemPage(
        icon: "assets/img/symbol_14_1.png",
        title: "Check your productivity",
        description: "Lorem Ipsum"),
  ];

  @override
  void initState() {
    super.initState();
    preff = SharedPreferences.getInstance();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 7,
              child: Stack(
                children: <Widget>[
                  PageView.builder(
                    itemBuilder: (context, position) {
                      return ItemPages(
                        itemPage: listPage[position],
                        pos: position,
                      );
                    },
                    controller: pageController,
                    itemCount: listPage.length,
                    onPageChanged: (pos){
                      currentPage = pos;
                      setState(() {
                        if(pos == 0){
                          disableBack = true;
                          disableSkip = false;
                          textStart = "Next";
                        }else if(pos == 1){
                          disableBack = false;
                          disableSkip = false;
                          textStart = "Next";
                        }else{
                          disableBack = false;
                          disableSkip = true;
                          textStart = "Let's Start";
                        }
                      });
                    },
                  ),
                  Positioned(
                    top: 1,
                    child: Container(
                      margin: EdgeInsets.only(top: 42),
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text("crillo.",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontFamily: Constants.font)),
                          IconButton(
                            icon:Text(
                            "Skip",
                            style: TextStyle(
                                color: !disableSkip ?ColorUtils.blue_app : Colors.transparent,
                                fontSize: 18,
                                fontFamily: Constants.font),
                          ), iconSize: 40,
                          onPressed: (){
                            if(!disableSkip){
                              Navigator.pushReplacement(context, 
                              MaterialPageRoute(builder: (context) => Home())
                             );
                            }
                          },
                          )
                          
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                color: ColorUtils.blue_app,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      IconButton(
                      icon:Text("Back",
                          style: TextStyle(
                              color: disableBack? Colors.transparent: Colors.white,
                              fontSize: 18,
                              fontFamily: Constants.font)),
                              iconSize: 40,
                       onPressed: (){
                          if(!disableBack){
                            currentPage--;
                            animate(currentPage);
                          }
                       },       
                      ),
                      DotsIndicator(
                        controller: pageController,
                        itemCount: 3,
                        onPageSelected: (int page) {
                          pageController.animateToPage(
                            page,
                            duration: Duration(milliseconds: 200),
                            curve: Curves.ease,
                          );
                        },
                      ),
                      IconButton(
                        onPressed: (){
                          if(textStart == "Next"){
                            currentPage++;
                            animate(currentPage);
                          }else{
                            
                            preff.then((pref){
                              pref.setBool('visibleIntro', false);
                            });
                           Navigator.pushReplacement(context, 
                            MaterialPageRoute(builder: (context) => Home())
                            );
                          }
                        },
                        icon:Text(
                          textStart,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: textStart == "Next" ? 18 : 16,
                              fontFamily: Constants.font),
                        ),
                        iconSize: textStart == "Next" ? 40 : 75,
                      )
                    ]),
              ),
            )
          ],
        ),
      ),
    );
  }

  void animate(int page){
     pageController.animateToPage(page,duration: Duration(milliseconds: 500),
                                        curve: Curves.ease);
  }

  
}

class ItemPages extends StatelessWidget {
  final ItemPage itemPage;
  final int pos;
  ItemPages({this.itemPage, this.pos});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  color: Colors.white,
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  color: ColorUtils.blue_app,
                ),
              ),
            ],
          ),
          Center(
            child: Image.asset(
              itemPage.icon,
              height: pos == 1 ? 290 : 210,
            ),
          ),
          Positioned(
            bottom: 1,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 200,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(itemPage.title,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: Constants.font)),
                  Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text(itemPage.description,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: Constants.font))),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class DotsIndicator extends AnimatedWidget {
  DotsIndicator({
    this.controller,
    this.itemCount,
    this.onPageSelected,
    this.color: Colors.white,
  }) : super(listenable: controller);

  /// The PageController that this DotsIndicator is representing.
  final PageController controller;

  /// The number of items managed by the PageController
  final int itemCount;

  /// Called when a dot is tapped
  final ValueChanged<int> onPageSelected;

  /// The color of the dots.
  ///
  /// Defaults to `Colors.white`.
  final Color color;

  // The base size of the dots
  static const double _kDotSize = 8.0;

  // The increase in the size of the selected dot
  static const double _kMaxZoom = 2.0;

  // The distance between the center of each dot
  static const double _kDotSpacing = 25.0;

  Widget _buildDot(int index) {
    double selectedness = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - ((controller.page ?? controller.initialPage) - index).abs(),
      ),
    );
    double zoom = 1.0 + (_kMaxZoom - 1.0) * selectedness;
    return new Container(
      color: Colors.transparent,
      width: _kDotSpacing,
      child: new Center(
        child: new Material(
          color: color,
          type: MaterialType.circle,
          child: new Container(
            width: _kDotSize * zoom,
            height: _kDotSize * zoom,
            child: new InkWell(
              onTap: () => onPageSelected(index),
            ),
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: new List<Widget>.generate(itemCount, _buildDot),
    );
  }
}
