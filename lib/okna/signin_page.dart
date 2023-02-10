import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:denikprogramatora/okna/app.dart';
import 'package:denikprogramatora/utils/loading_widget.dart';
import 'package:denikprogramatora/utils/my_container.dart';
import 'package:denikprogramatora/utils/vzhled.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher_string.dart';

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

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool showSignIn = true;
  bool isLoading = true;

  TextEditingController emailCon = TextEditingController();
  TextEditingController passwordCon = TextEditingController();
  TextEditingController nameCon = TextEditingController();

  String jazyk = "C#";

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      if (FirebaseAuth.instance.currentUser != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (c) => const HlavniOkno()),
        );
      }

      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const LoadingWidget()
          : Stack(
              children: [
                Center(
                  child: showSignIn ? signInWidget() : registerWidget(),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: TextButton(
                    onPressed: () => showAboutDialog(
                        context: context,
                        applicationName: "Kodelog",
                        applicationVersion: "1.1.0",
                        applicationLegalese:
                            "©️ 2023 Matyáš Caras a Richard Pavlikán,\n vydáno pod licencí AGPLv3",
                        children: [
                          TextButton(
                            child: const Text("Zdrojový kód"),
                            onPressed: () => launchUrlString(
                                "https://github.com/Royal-Buccaneers/kodelog"),
                          )
                        ]),
                    child: const Text(
                      "Licence",
                      style: Vzhled.textBtn,
                    ),
                  ),
                )
              ],
            ),
    );
  }

  Widget signInWidget() {
    GlobalKey<FormState> form = GlobalKey<FormState>();
    return MyContainer(
      height: 70.h,
      width: (Device.screenType == ScreenType.mobile) ? 80.w : 40.w,
      child: Form(
        key: form,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Kodelog",
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: (Device.screenType == ScreenType.mobile) ? 60.w : 30.w,
              child: TextFormField(
                decoration: Vzhled.inputDecoration("E-mail"),
                cursorColor: Vzhled.textColor,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                controller: emailCon,
                onFieldSubmitted: (_) {
                  if (form.currentState!.validate()) {
                    signIn();
                  }
                },
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return "Toto pole je povinné!";
                  } else if (!RegExp(r'[\w\.]+@[a-z0-9]+\.[a-z]{1,3}')
                      .hasMatch(value)) {
                    return "Neplatný e-mail!";
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: (Device.screenType == ScreenType.mobile) ? 60.w : 30.w,
              child: TextFormField(
                decoration: Vzhled.inputDecoration("Heslo"),
                cursorColor: Vzhled.textColor,
                autocorrect: false,
                obscureText: true,
                controller: passwordCon,
                onFieldSubmitted: (_) {
                  if (form.currentState!.validate()) {
                    signIn();
                  }
                },
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return "Toto pole je povinné!";
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            OutlinedButton(
              style: Vzhled.orangeCudlik,
              onPressed: () {
                if (form.currentState!.validate()) {
                  signIn();
                }
              },
              child: const Text("Přihlásit se"),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text("nebo"),
            const SizedBox(
              height: 10,
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  showSignIn = false;
                });
              },
              child: const Text("Registrovat se", style: Vzhled.textBtn),
            )
          ],
        ),
      ),
    );
  }

  Widget registerWidget() {
    GlobalKey<FormState> form = GlobalKey<FormState>();
    return MyContainer(
      width: (Device.screenType == ScreenType.mobile) ? 80.w : 40.w,
      child: Form(
        key: form,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Kodelog",
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: (Device.screenType == ScreenType.mobile) ? 60.w : 30.w,
              child: TextFormField(
                decoration: Vzhled.inputDecoration("Jméno"),
                cursorColor: Vzhled.textColor,
                controller: nameCon,
                onFieldSubmitted: (_) {
                  if (form.currentState!.validate()) {
                    signUp();
                  }
                },
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return "Toto pole je povinné!";
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: (Device.screenType == ScreenType.mobile) ? 60.w : 30.w,
              child: TextFormField(
                decoration: Vzhled.inputDecoration("E-mail"),
                cursorColor: Vzhled.textColor,
                controller: emailCon,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                onFieldSubmitted: (_) {
                  if (form.currentState!.validate()) {
                    signUp();
                  }
                },
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return "Toto pole je povinné!";
                  } else if (!RegExp(r'[\w\.]+@[a-z0-9]+\.[a-z]{1,3}')
                      .hasMatch(value)) {
                    return "Neplatný e-mail!";
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: (Device.screenType == ScreenType.mobile) ? 60.w : 30.w,
              child: TextFormField(
                decoration: Vzhled.inputDecoration("Heslo"),
                cursorColor: Vzhled.textColor,
                obscureText: true,
                controller: passwordCon,
                onFieldSubmitted: (_) {
                  if (form.currentState!.validate()) {
                    signUp();
                  }
                },
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return "Toto pole je povinné!";
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Oblíbený jazyk:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 5),
                DropdownButton(
                  value: jazyk,
                  dropdownColor: Vzhled.backgroundColor,
                  items: jazyky
                      .map(
                        (e) => DropdownMenuItem(
                          value: e["jazyk"],
                          child: Text(e["jazyk"]),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      jazyk = (value as String?)!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            OutlinedButton(
              style: Vzhled.orangeCudlik,
              onPressed: () async {
                if (form.currentState!.validate()) {
                  signUp();
                }
              },
              child: const Text("Registrovat se"),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text("nebo"),
            const SizedBox(
              height: 10,
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  showSignIn = true;
                });
              },
              child: const Text("Přihlásit se", style: Vzhled.textBtn),
            )
          ],
        ),
      ),
    );
  }

  void signIn() {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: emailCon.text, password: passwordCon.text)
        .then(
          (value) => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (c) => const HlavniOkno()),
          ),
        )
        .onError((e, st) {
      if (e.toString().contains("firebase_auth/user-not-found")) {
        showDialog(
          context: context,
          builder: (c) => const AlertDialog(
            title: Text("Chyba"),
            content: Text("Váš účet neexistuje"),
          ),
        );
      } else if (e.toString().contains("firebase_auth/wrong-password")) {
        showDialog(
          context: context,
          builder: (c) => const AlertDialog(
            title: Text("Chyba"),
            content: Text("Zadáváte špatné heslo!"),
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (c) => const AlertDialog(
            title: Text("Chyba"),
            content: Text("Nastala neznámá chyba."),
          ),
        );
        debugPrint(e.toString());
      }
    });
  }

  void signUp() {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: emailCon.text, password: passwordCon.text)
        .then(
      (value) async {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set({
          "name": nameCon.text,
          "email": emailCon.text,
          "favourite": jazyk,
        });
        value.user?.updateDisplayName(nameCon.text);

        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (c) => const HlavniOkno()),
        );
      },
    ).onError((error, stackTrace) {
      if (error.toString().contains("firebase_auth/email-already-in-use")) {
        showDialog(
          context: context,
          builder: (c) => const AlertDialog(
            title: Text("Chyba"),
            content: Text("E-mail je již zaregistrovaný"),
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (c) => const AlertDialog(
            title: Text("Chyba"),
            content: Text("Nastala neznámá chyba."),
          ),
        );
        debugPrint(error.toString());
      }
    });
  }
}
