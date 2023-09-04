import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  final Color _primaryColorLight = const Color(0xFF404B47);
  final Color _secondaryColorLight = const Color(0xFFCB974E);
  final _bgColorLight = Colors.white;
  final Color _winColorLight = const Color(0xFF00FF7F);

  final Color _primaryColorDark = const Color(0xFFB95300);
  final Color _secondaryColorDark = const Color(0xFFF39C11);
  final Color _bgColorDark = const Color(0xFFFBE5A9);
  final Color _winColorDark = const Color(0xFF00FF7F);

  bool _isLight = true;
  bool showLoading = true;

  ThemeProvider.init() {
    showLoading = true;
    notifyListeners();

    getPrefs();
  }

  void getPrefs() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool? val = preferences.getBool("isLight");

    if (val == null) {
      _isLight = true;
    } else {
      _isLight = val;
    }

    print("Theme isLight: $_isLight");
    showLoading = false;
    notifyListeners();
  }

  void setPrefs(bool value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool("isLight", value);
  }

  Color get primaryColor {
    return _isLight ? _primaryColorLight : _primaryColorDark;
  }

  Color get secondaryColor {
    return _isLight ? _secondaryColorLight : _secondaryColorDark;
  }

  Color get bgColor {
    return _isLight ? _bgColorLight : _bgColorDark;
  }

  Color get winColor {
    return _isLight ? _winColorLight : _winColorDark;
  }

  bool get isLightTheme {
    return _isLight;
  }

  void changeTheme() {
    _isLight = !_isLight;
    setPrefs(_isLight);
    notifyListeners();
  }
}
