import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stetho/flutter_stetho.dart';
import 'package:pomodoro_apps/utils/color_utils.dart';
import 'package:pomodoro_apps/utils/constants.dart';
import 'package:pomodoro_apps/widget/home/home.dart';
import 'package:pomodoro_apps/widget/intro/intro.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
   Stetho.initialize();
  runApp(MyApp());
}


class MyApp extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _MyApp();
}

class _MyApp extends State<MyApp>{
  Widget initWidget = Container();
  @override
  void initState() {
    super.initState();
    final preff = SharedPreferences.getInstance();
    preff.then((preff){
      if(preff.getBool('visibleIntro') != null && !preff.getBool('visibleIntro')){
        setState(() {
          initWidget = Home();
        });
        print('home');
      }else{
         setState(() =>initWidget = Intro());
        print('intro');
      }
    });
  }
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Crillo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: ColorUtils.bg_home,
        textTheme: TextTheme(
          title: TextStyle(fontFamily: Constants.font)
        )
      ),
      home: initWidget,
    );
  }

}

