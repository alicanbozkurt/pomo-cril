class CrilData{
  final String crilName;
  final Focussing focussing;
  final int longBreak;
  final int targetCrill;

  CrilData({this.crilName, this.focussing, this.longBreak, this.targetCrill}); 
}

enum Focussing{
  Relax,
  Normal,
  NoBlinking
}

class Setting{
  final bool isRinging;
  final bool isVibrate;
  Setting({this.isRinging, this.isVibrate});
}