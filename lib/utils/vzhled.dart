import 'package:flutter/material.dart';

class Vzhled {
  static const purple = Color.fromARGB(255, 105, 108, 180);
  static const textColor = Color(0xfff1f1f3);
  static const orange = Color(0xffff8200); //f58f29);
  static const backgroundColor = Color(0xff17161b);
  static const dialogColor = Color(0xff28272c);

  /// Normální tučný velký nadpis
  static const TextStyle nadpis =
      TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: textColor);

  /// Styl nadpisu v dialogu
  static const TextStyle dialogNadpis =
      TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor);

  /// Text o velikosti nadpisu, ale normální tloušťka
  static const TextStyle velkyText = TextStyle(fontSize: 22, color: textColor);

  static const double text = 14;

  /// Větší text, ale ne tučný
  static const TextStyle mensiAleVelkyText =
      TextStyle(fontSize: 16, color: textColor);

  static final ButtonStyle purpleCudlik = OutlinedButton.styleFrom(
    backgroundColor: purple,
    foregroundColor: textColor,
    padding: const EdgeInsets.only(top: 15, bottom: 15, left: 20, right: 20),
    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  );

  static final ButtonStyle orangeCudlik = OutlinedButton.styleFrom(
    backgroundColor: orange,
    foregroundColor: Colors.black,
    padding: const EdgeInsets.only(top: 15, bottom: 15, left: 20, right: 20),
    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  );

  static const TextStyle textBtn = TextStyle(
    color: Vzhled.purple,
    fontWeight: FontWeight.bold,
    decoration: TextDecoration.underline,
  );

  static InputDecoration inputDecoration(String text) {
    return InputDecoration(
      labelStyle: const TextStyle(color: Vzhled.textColor),
      label: Text(
        text,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
            color: Color.fromARGB(255, 173, 173, 173), width: 2.0),
        borderRadius: BorderRadius.circular(6.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Vzhled.purple, width: 2.0),
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }
}
