import 'package:denikprogramatora/okna/app.dart';
import 'package:denikprogramatora/okna/signin_page.dart';
import 'package:denikprogramatora/okna/users_page.dart';
import 'package:denikprogramatora/utils/devicecontainer.dart';
import 'package:denikprogramatora/utils/loading_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher_string.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import '../utils/csv.dart';
import '../utils/my_container.dart';
import '../utils/new_record_dialog.dart';
import '../utils/vzhled.dart';
import 'all_records.dart';

class NastaveniOkno extends StatefulWidget {
  const NastaveniOkno({super.key});

  @override
  State<NastaveniOkno> createState() => _NastaveniOknoState();
}

class _NastaveniOknoState extends State<NastaveniOkno> {
  var _loading = true;
  var name = "error";
  bool isAdmin = false;

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

        isAdmin = value["isAdmin"];
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                        10,
                                      ),
                                    ),
                                    color: Vzhled.purple),
                                width: 400,
                                child: InkWell(
                                  onTap: () => showEditJazyk(),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Text(
                                          "Oblíbený jazyk",
                                          style: Vzhled.nadpis,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                        10,
                                      ),
                                    ),
                                    color: Vzhled.purple),
                                width: 400,
                                child: InkWell(
                                  onTap: () => showCategoriesDialog(context, [],
                                      jenMenit: true),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Text(
                                          "Upravit kategorie",
                                          style: Vzhled.nadpis,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              DeviceContainer(
                                mainAxisAlignmentDesktop:
                                    MainAxisAlignment.center,
                                mainAxisAlignmentMobile:
                                    MainAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(
                                            10,
                                          ),
                                        ),
                                        color: Vzhled.purple),
                                    width: 400,
                                    child: InkWell(
                                      onTap: () async {
                                        var csv = await exportCsv();
                                        var blob = html.Blob([csv]);
                                        var url =
                                            html.Url.createObjectUrlFromBlob(
                                                blob);
                                        var anchor = html.document
                                                .createElement('a')
                                            as html.AnchorElement
                                          ..href = url
                                          ..style.display = 'none'
                                          ..download =
                                              'db_${name.replaceAll(" ", "_")}.csv';
                                        html.document.body!.children
                                            .add(anchor);

                                        anchor.click();

                                        html.document.body!.children
                                            .remove(anchor);
                                        html.Url.revokeObjectUrl(url);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Text(
                                              "Exportovat CSV",
                                              style: Vzhled.nadpis,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                    height: 10,
                                  ),
                                  Container(
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(
                                            10,
                                          ),
                                        ),
                                        color: Vzhled.purple),
                                    width: 400,
                                    child: InkWell(
                                      onTap: () async {
                                        try {
                                          var p = await importCsv(name);
                                          if (p != -1) {
                                            if (!mounted) return;
                                            showDialog(
                                              context: context,
                                              builder: (c) => AlertDialog(
                                                title: const Text("Úspěch!"),
                                                content: Text(
                                                    "Importováno $p záznamů"),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () =>
                                                          Navigator.of(c).pop(),
                                                      child: const Text("Ok"))
                                                ],
                                              ),
                                            );
                                          }
                                        } catch (e) {
                                          showDialog(
                                            context: context,
                                            builder: (c) => AlertDialog(
                                              title: const Text(
                                                  "Při importování nastala chyba!"),
                                              content: Text(e.toString()),
                                            ),
                                          );
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Text(
                                              "Importovat CSV",
                                              style: Vzhled.nadpis,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              if (isAdmin)
                                Container(
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(
                                          10,
                                        ),
                                      ),
                                      color: Vzhled.purple),
                                  width: 400,
                                  child: InkWell(
                                    onTap: () => Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const UsersPage(),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Text(
                                            "Správa uživatelů",
                                            style: Vzhled.nadpis,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  showEditJazyk() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Oblíbený jazyk", style: Vzhled.velkyText),
        scrollable: true,
        content: SizedBox(
          width: 20.w,
          child: StreamBuilder(
              stream: ref.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return DropdownButton(
                      value: snapshot.data!.data()!["favourite"],
                      dropdownColor: Vzhled.backgroundColor,
                      items: jazyky
                          .map(
                            (e) => DropdownMenuItem(
                              value: e["jazyk"],
                              child: SizedBox(
                                  width: 17.w, child: Text(e["jazyk"])),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        ref.update({"favourite": value!});
                      });
                }
                return const LoadingWidget();
              }),
        ),
      ),
    );
  }
}
