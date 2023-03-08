import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:denikprogramatora/okna/all_records.dart';
import 'package:denikprogramatora/okna/signin_page.dart';
import 'package:denikprogramatora/utils/devicecontainer.dart';
import 'package:denikprogramatora/utils/loading_widget.dart';
import 'package:denikprogramatora/utils/my_container.dart';
import 'package:denikprogramatora/utils/new_record_dialog.dart';
import 'package:denikprogramatora/utils/really_delete.dart';
import 'package:denikprogramatora/utils/vzhled.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'app.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  var _loading = true;
  var name = "error";
  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser == null) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (c) => const SignInPage()),
          (route) => false);
      return;
    }

    ref.get().then((value) {
      setState(() {
        name = FirebaseAuth.instance.currentUser!.displayName ??
            value[
                "name"]; // fallback když uživatel je vytvořen skrz firebase admin
      });
    });

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: 90.w,
            height: 100.h,
            child: (_loading)
                ? const LoadingWidget()
                : Column(
                    children: [
                      DeviceContainer(
                        mainAxisAlignmentDesktop:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          MyContainer(
                            width: (Device.screenType == ScreenType.mobile)
                                ? 90.w
                                : 35.w,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (name != "error") Text("Ahoj $name"),
                                TextButton(
                                  onPressed: () => showAboutDialog(
                                      context: context,
                                      applicationName: "Kodelog",
                                      applicationVersion: "2.0.1",
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
                                TextButton(
                                  onPressed: () async {
                                    await FirebaseAuth.instance.signOut();
                                    if (!mounted) return;
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (c) => const SignInPage()),
                                        (route) => false);
                                  },
                                  child: const Text(
                                    "Odhlásit se",
                                    style: Vzhled.textBtn,
                                  ),
                                )
                              ],
                            ),
                          ),
                          MyContainer(
                            width: (Device.screenType == ScreenType.mobile)
                                ? 90.w
                                : 40.w,
                            child: DeviceContainer(
                              mainAxisAlignmentDesktop:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () => Navigator.of(context)
                                      .pushReplacement(MaterialPageRoute(
                                          builder: (context) =>
                                              const HlavniOkno())),
                                  child: const Text(
                                    "Denní přehled",
                                    style: TextStyle(color: Vzhled.textColor),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const AllRecordsPage()));
                                  },
                                  child: const Text(
                                    "Všechny\nzáznamy",
                                    style: TextStyle(color: Vzhled.textColor),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                TextButton(
                                  onPressed: () {},
                                  child: const Text(
                                    "Nastavení",
                                    style: TextStyle(
                                      color: Vzhled.textColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                OutlinedButton(
                                  onPressed: () =>
                                      showCreateItemDialog(context),
                                  style: Vzhled.orangeCudlik,
                                  child: const Text(
                                    "Přidat záznam",
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Expanded(
                        child: MyContainer(
                          width: 90.w,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const Text("Uživatelé",
                                        style: Vzhled.mensiAleVelkyText),
                                    OutlinedButton(
                                      onPressed: () => showNewUser(),
                                      style: Vzhled.orangeCudlik,
                                      child: const Text(
                                        "Přidat uživatele",
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 40),
                                const Padding(
                                  padding: EdgeInsets.only(right: 8.0, left: 8),
                                  child: DeviceContainer(
                                    mainAxisAlignmentDesktop:
                                        MainAxisAlignment.spaceBetween,
                                    mainAxisAlignmentMobile:
                                        MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 100,
                                        child: Text(
                                          "Jméno",
                                        ),
                                      ),
                                      SizedBox(
                                        width: 150,
                                        child: Text(
                                          "Email",
                                        ),
                                      ),
                                      SizedBox(
                                        width: 150,
                                        child: Text("Username"),
                                      ),
                                      SizedBox(
                                        width: 50,
                                        child: Text("Admin"),
                                      ),
                                      Text("Nastavení")
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: 80.w,
                                  child: const Divider(color: Vzhled.purple),
                                ),
                                const SizedBox(height: 20),
                                SingleChildScrollView(
                                  child: StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection("users")
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasError) {
                                          return const Text(
                                              "Nastal error :C...");
                                        } else if (snapshot.hasData) {
                                          var docs = snapshot.data!.docs;
                                          return Column(
                                            children: List.generate(
                                              docs.length,
                                              (index) {
                                                var data = docs[index].data();

                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: DeviceContainer(
                                                    mainAxisAlignmentDesktop:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    mainAxisAlignmentMobile:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(
                                                        width: 100,
                                                        child: Text(
                                                          data["name"],
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 150,
                                                        child: Text(
                                                          data["email"],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 150,
                                                        child: Text(
                                                            data["username"] ??
                                                                "Prozatím nic"),
                                                      ),
                                                      SizedBox(
                                                        width: 50,
                                                        child: Icon(
                                                            data["isAdmin"] ??
                                                                    false
                                                                ? Icons.done
                                                                : Icons
                                                                    .do_disturb),
                                                      ),
                                                      (data["username"] !=
                                                              "admin")
                                                          ? PopupMenuButton(
                                                              onSelected:
                                                                  (value) {
                                                                switch (value) {
                                                                  case 'Změnit práva':
                                                                    showPrava(
                                                                        docs[index]
                                                                            .id,
                                                                        data[
                                                                            "isAdmin"]);
                                                                    break;
                                                                  case "Upravit username":
                                                                    showUpravitUsername(
                                                                        docs[index]
                                                                            .id,
                                                                        data[
                                                                            "username"]);
                                                                    break;
                                                                  case 'Odstranit':
                                                                    showOdstranit(
                                                                        docs[index]
                                                                            .id);
                                                                    break;
                                                                }
                                                              },
                                                              itemBuilder:
                                                                  (BuildContext
                                                                      context) {
                                                                return {
                                                                  'Změnit práva',
                                                                  "Upravit username",
                                                                  'Odstranit'
                                                                }.map((String
                                                                    choice) {
                                                                  return PopupMenuItem<
                                                                      String>(
                                                                    value:
                                                                        choice,
                                                                    child: Text(
                                                                        choice),
                                                                  );
                                                                }).toList();
                                                              },
                                                            )
                                                          : const SizedBox(
                                                              width: 40)
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        }
                                        return const LoadingWidget();
                                      }),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  showNewUser() async {
    GlobalKey<FormState> key = GlobalKey<FormState>();
    String jmeno = "";
    String email = "";
    String username = "";
    bool isAdmin = false;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Nový uživatel", style: Vzhled.velkyText),
        scrollable: true,
        content: StatefulBuilder(
          builder: (context, setState) {
            return SizedBox(
              width: 50.w,
              child: Form(
                key: key,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: Vzhled.inputDecoration("Jméno"),
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return "Toto pole je povinné!";
                        }
                        return null;
                      },
                      onChanged: (value) {
                        jmeno = value;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: Vzhled.inputDecoration("Username"),
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return "Toto pole je povinné!";
                        }
                        return null;
                      },
                      onChanged: (value) {
                        username = value;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: Vzhled.inputDecoration("Email"),
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return "Toto pole je povinné!";
                        } else if (!RegExp(r'[\w\.]+@[a-z0-9]+\.[a-z]{1,3}')
                            .hasMatch(value)) {
                          return "Neplatný e-mail!";
                        }
                        return null;
                      },
                      onChanged: (value) {
                        email = value;
                      },
                    ),
                    const SizedBox(height: 10),
                    DropdownButton(
                      value: isAdmin,
                      items: ["Admin", "Uživatel"]
                          .map((e) => DropdownMenuItem(
                              value: e == "Admin" ? true : false,
                              child: Text(e)))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          isAdmin = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    OutlinedButton(
                      style: Vzhled.orangeCudlik,
                      onPressed: () async {
                        if (key.currentState!.validate()) {
                          // kontrola ci niekto nevyuziva username
                          var usernameRef = await FirebaseFirestore.instance
                              .collection("users")
                              .where("username", isEqualTo: username)
                              .get();

                          if (usernameRef.docs.isNotEmpty) {
                            // ignore: use_build_context_synchronously
                            showDialog(
                              context: context,
                              builder: (c) => const AlertDialog(
                                title: Text("Chyba"),
                                content: Text(
                                    "Toto username patří jinému uživateli, prosím napište nové username."),
                              ),
                            );

                            return;
                          }

                          // kontrola ci niekto nevyuziva email
                          var emailRef = await FirebaseFirestore.instance
                              .collection("users")
                              .where("email", isEqualTo: email)
                              .get();

                          if (emailRef.docs.isNotEmpty) {
                            // ignore: use_build_context_synchronously
                            showDialog(
                              context: context,
                              builder: (c) => const AlertDialog(
                                title: Text("Chyba"),
                                content: Text(
                                    "Tento email patří jinému uživateli, prosím jiný email."),
                              ),
                            );

                            return;
                          }

                          FirebaseFirestore.instance.collection("users").add({
                            "email": email,
                            "name": jmeno,
                            "isAdmin": isAdmin,
                            "favourite": "Dart",
                            "username": username
                          }).then((value) {
                            Navigator.of(context, rootNavigator: true)
                                .pop("dialog");

                            showDialog(
                              context: context,
                              builder: (_) => const AlertDialog(
                                  scrollable: true,
                                  content: Text("Uživatel vytvořen")),
                            );
                          });
                        }
                      },
                      child: const Text("Přidat"),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Uživatel si při prvním přihlášení vytvoří heslo sám",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  showUpravitUsername(id, oldUsername) async {
    GlobalKey<FormState> key = GlobalKey<FormState>();
    String newUsername = oldUsername;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Username", style: Vzhled.velkyText),
        scrollable: true,
        content: SizedBox(
          width: 50.w,
          child: Form(
            key: key,
            child: Column(
              children: [
                TextFormField(
                  initialValue: oldUsername,
                  decoration: Vzhled.inputDecoration("Nové username"),
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return "Toto pole je povinné!";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    newUsername = value;
                  },
                ),
                const SizedBox(height: 15),
                OutlinedButton(
                    style: Vzhled.orangeCudlik,
                    onPressed: () async {
                      if (key.currentState!.validate()) {
                        // kontrola ci niekto nevyuziva username
                        var usernameRef = await FirebaseFirestore.instance
                            .collection("users")
                            .where("username", isEqualTo: newUsername)
                            .get();

                        if (newUsername.isEmpty) {
                          // ignore: use_build_context_synchronously
                          showDialog(
                            context: context,
                            builder: (c) => const AlertDialog(
                              title: Text("Chyba"),
                              content: Text("Toto pole je povinné!"),
                            ),
                          );

                          return;
                        }

                        if (usernameRef.docs.isNotEmpty &&
                            oldUsername != newUsername) {
                          // ignore: use_build_context_synchronously
                          showDialog(
                            context: context,
                            builder: (c) => const AlertDialog(
                              title: Text("Chyba"),
                              content: Text(
                                  "Toto username patří jinému uživateli, prosím napište nové username."),
                            ),
                          );

                          return;
                        }

                        FirebaseFirestore.instance
                            .collection("users")
                            .doc(id)
                            .update({"username": newUsername}).then((value) =>
                                Navigator.of(context, rootNavigator: true)
                                    .pop("dialog"));
                      }
                    },
                    child: const Text("Uložit"))
              ],
            ),
          ),
        ),
      ),
    );
  }

  showPrava(id, isAdmin) async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Práva uživatele", style: Vzhled.velkyText),
        scrollable: true,
        content: SizedBox(
            width: 20.w,
            child: DropdownButton(
              value: isAdmin,
              items: ["Admin", "Uživatel"]
                  .map((e) => DropdownMenuItem(
                      value: e == "Admin" ? true : false, child: Text(e)))
                  .toList(),
              onChanged: (value) {
                FirebaseFirestore.instance
                    .collection("users")
                    .doc(id)
                    .update({"isAdmin": value});

                Navigator.of(context, rootNavigator: true).pop("dialog");
              },
            )),
      ),
    );
  }

  showOdstranit(id) async {
    showReallyDelete(context, () {
      FirebaseFirestore.instance.collection("users").doc(id).delete();
      Navigator.of(context, rootNavigator: true).pop("dialog");
    }, doNavigatorPop: false);
  }
}
