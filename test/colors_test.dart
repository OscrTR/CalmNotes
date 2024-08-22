import 'package:calm_notes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CustomColors', () {
    test('primaryColor is defined correctly', () {
      expect(CustomColors.primaryColor, const Color(0xff444444));
    });

    test('secondaryColor is defined correctly', () {
      expect(CustomColors.secondaryColor, const Color(0xffc1bdba));
    });

    test('ternaryColor is defined correctly', () {
      expect(CustomColors.ternaryColor, const Color(0xff8a9193));
    });

    test('white is defined correctly', () {
      expect(CustomColors.white, const Color(0xffffffff));
    });

    test('backgroundColor is defined correctly', () {
      expect(CustomColors.backgroundColor, const Color(0xfff7f2ed));
    });

    test('moodColors list is correctly defined', () {
      final expectedColors = [
        const Color(0xfffedac2),
        const Color(0xffffe4ca),
        const Color(0xffffe7c8),
        const Color(0xfffee9c4),
        const Color(0xfffeecc2),
        const Color(0xfffeefbf),
        const Color(0xfff6efc2),
        const Color(0xffebefc4),
        const Color(0xffe4f0c6),
        const Color(0xffdcf0c9),
        const Color(0xffc9eec0),
      ];

      expect(moodColors, expectedColors);
    });
  });
}
