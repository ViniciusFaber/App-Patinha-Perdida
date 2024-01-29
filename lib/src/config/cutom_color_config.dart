import 'package:flutter/material.dart';

//Definição de cores customizadas para o aplicativo
Map<int, Color> _swatchOpacity = {
  50: const Color.fromRGBO(179, 163, 186, .1),
  100: const Color.fromRGBO(179, 163, 186, .2),
  200: const Color.fromRGBO(179, 163, 186, .3),
  300: const Color.fromRGBO(179, 163, 186, .4),
  400: const Color.fromRGBO(179, 163, 186, .5),
  500: const Color.fromRGBO(179, 163, 186, .6),
  600: const Color.fromRGBO(179, 163, 186, .7),
  700: const Color.fromRGBO(179, 163, 186, .8),
  800: const Color.fromRGBO(179, 163, 186, .9),
  900: const Color.fromRGBO(179, 163, 186, 1),
};

Map<int, Color> _swatchOpacityPueple = {
  50: const Color.fromRGBO(104, 80, 123, .1),
  100: const Color.fromRGBO(104, 80, 123, .2),
  200: const Color.fromRGBO(104, 80, 123, .3),
  300: const Color.fromRGBO(104, 80, 123, .4),
  400: const Color.fromRGBO(104, 80, 123, .5),
  500: const Color.fromRGBO(104, 80, 123, .6),
  600: const Color.fromRGBO(104, 80, 123, .7),
  700: const Color.fromRGBO(104, 80, 123, .8),
  800: const Color.fromRGBO(104, 80, 123, .9),
  900: const Color.fromRGBO(104, 80, 123, 1),
};

abstract class CustomColors {
//Cor vermelha usada no aplicativo para indicar alertas
  static Color customContrastColor = Colors.red.shade700;

//Cor violeta em tons mais claros usada nos ícones e containers
  static MaterialColor customSwatchColor =
      MaterialColor(0xffB3A3BA, _swatchOpacity);

//Cor violeta em tons mais escuros usada no appBar
  static MaterialColor customSwatchColorPurple =
      MaterialColor(0xff68507B, _swatchOpacityPueple);
}
