import 'package:flutter/material.dart';

class AnimationStateNotifier extends ChangeNotifier {
  bool _animate = false;

  bool get animate => _animate;

  void setAnimate(bool value) {
    _animate = value;
    notifyListeners();
  }
}
