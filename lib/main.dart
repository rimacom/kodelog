import 'package:denikprogramatora/okna/signin_page.dart';
import 'package:denikprogramatora/utils/vzhled.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'firebase_options.dart'; //TODO: Přidejte si vlastní firebase nastavení

/*
        Copyright (C) 2022 Matyáš Caras a Richard Pavlikán

        This program is free software: you can redistribute it and/or modify
        it under the terms of the GNU Affero General Public License as
        published by the Free Software Foundation, either version 3 of the
        License, or (at your option) any later version.

        This program is distributed in the hope that it will be useful,
        but WITHOUT ANY WARRANTY; without even the implied warranty of
        MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
        GNU Affero General Public License for more details.

        You should have received a copy of the GNU Affero General Public License
        along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions
        .currentPlatform, //TODO: Přidejte si vlastní firebase nastavení
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (p0, p1, p2) => MaterialApp(
        title: 'Deník Programátora',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Vzhled.backgroundColor,
          textTheme: Theme.of(context).textTheme.apply(
                bodyColor: Vzhled.textColor,
                displayColor: Vzhled.textColor,
                fontSizeDelta: 2,
                fontSizeFactor: 0.8,
              ),
          colorScheme: const ColorScheme(
              background: Vzhled.dialogColor,
              onBackground: Vzhled.textColor,
              brightness: Brightness.dark,
              primary: Colors.blue,
              onPrimary: Vzhled.textColor,
              secondary: Colors.purple,
              onSecondary: Vzhled.textColor,
              error: Colors.red,
              onError: Vzhled.textColor,
              surface: Vzhled.backgroundColor,
              onSurface: Vzhled.textColor),
          dialogBackgroundColor: Vzhled.dialogColor,
        ),
        localizationsDelegates: const [
          ...GlobalMaterialLocalizations.delegates
        ],
        supportedLocales: const [Locale("cs")],
        debugShowCheckedModeBanner: false,
        home: const SignInPage(),
      ),
    );
  }
}
