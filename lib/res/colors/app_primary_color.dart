import 'package:flutter/material.dart';

const MaterialColor primary = MaterialColor(_primaryPrimaryValue, <int, Color>{
  50: Color(0xFFE4EEE8),
  100: Color(0xFFBBD4C6),
  200: Color(0xFF8EB7A0),
  300: Color(0xFF609A7A),
  400: Color(0xFF3E845E),
  500: Color(_primaryPrimaryValue),
  600: Color(0xFF19663B),
  700: Color(0xFF145B32),
  800: Color(0xFF11512A),
  900: Color(0xFF093F1C),
});
const int _primaryPrimaryValue = 0xFF1C6E41;

const MaterialColor primaryAccent =
    MaterialColor(_primaryAccentValue, <int, Color>{
  100: Color(0xFF77FF9F),
  200: Color(_primaryAccentValue),
  400: Color(0xFF11FF57),
  700: Color(0xFF00F649),
});
const int _primaryAccentValue = 0xFF44FF7B;
