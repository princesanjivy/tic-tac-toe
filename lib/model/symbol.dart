class PlaySymbol {
  static const String _symbolX = "X";
  static const String _symbolO = "O";
  static const String _symbolDraw = "Draw";

  static const int _symbolXInt = 1;
  static const int _symbolOInt = 2;

  static get x {
    return _symbolX;
  }

  static get o {
    return _symbolO;
  }

  static get draw {
    return _symbolDraw;
  }

  static get xInt {
    return _symbolXInt;
  }

  static get oInt {
    return _symbolOInt;
  }

  static int inNum(String symbol) {
    // can be rewritten using map
    if (symbol == _symbolX) {
      return _symbolXInt;
    }
    if (symbol == _symbolO) {
      return _symbolOInt;
    }

    return 0;
  }
}
