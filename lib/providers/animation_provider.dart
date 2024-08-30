import 'package:flutter/material.dart';

class AnimationStateNotifier extends ChangeNotifier {
  bool _animate = false;

  bool get animate => _animate;

  Future<void> setAnimate(bool value) async {
    _animate = value;
    notifyListeners();
  }
}
