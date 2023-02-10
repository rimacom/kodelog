import 'package:flutter/material.dart';

InputDecoration inputDecoration(String text) {
  return InputDecoration(
    labelStyle: const TextStyle(color: Colors.white),
    label: Text(
      text,
    ),
    border: UnderlineInputBorder(
        borderSide: const BorderSide(color: Colors.black, width: 2.0),
        borderRadius: BorderRadius.circular(6.0)),
    focusedBorder: UnderlineInputBorder(
      borderSide: const BorderSide(color: Color(0xffCA1F3D), width: 2.0),
      borderRadius: BorderRadius.circular(10.0),
    ),
  );
}
