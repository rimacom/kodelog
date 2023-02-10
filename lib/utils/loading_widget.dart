import 'package:denikprogramatora/utils/vzhled.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: Vzhled.purple,
      ),
    );
  }
}

final jazyky = <Map<String, dynamic>>[
  {"jazyk": "C#", "barva": 0xff8200f3},
  {"jazyk": "JavaScript", "barva": 0xfffdd700},
  {"jazyk": "Python", "barva": 0xff0080ee},
  {"jazyk": "PHP🤢", "barva": 0xff00abff},
  {"jazyk": "C++", "barva": 0xff1626ff},
  {"jazyk": "Kotlin", "barva": 0xffe34b7c},
  {"jazyk": "Java", "barva": 0xfff58219},
  {"jazyk": "Dart", "barva": 0xff40c4ff},
  {"jazyk": "F#", "barva": 0xff85ddf3},
  {"jazyk": "Elixir", "barva": 0xff543465},
  {"jazyk": "Carbon", "barva": 0xff606060}
];
