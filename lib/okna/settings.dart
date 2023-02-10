import 'package:denikprogramatora/okna/app.dart';
import 'package:denikprogramatora/okna/signin_page.dart';
import 'package:denikprogramatora/utils/devicecontainer.dart';
import 'package:denikprogramatora/utils/loading_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../utils/my_container.dart';
import '../utils/new_record_dialog.dart';
import '../utils/vzhled.dart';
import 'all_records.dart';

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

class NastaveniOkno extends StatefulWidget {
  const NastaveniOkno({super.key});

  @override
  State<NastaveniOkno> createState() => _NastaveniOknoState();
}

class _NastaveniOknoState extends State<NastaveniOkno> {
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
    name = FirebaseAuth.instance.currentUser!.displayName!;

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
              : Column(children: [
                  DeviceContainer(
                    mainAxisAlignmentDesktop: MainAxisAlignment.spaceBetween,
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
                              onPressed: () => showCreateItemDialog(context),
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
                              color: Vzhled.purple,
                            ),
                            width: 400,
                            child: InkWell(
                              onTap: () => showProgrammersDialog(context,
                                  jenMenit: true),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      "Upravit programátory",
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
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                        ]),
                  ))
                ]),
        ),
      )),
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
            ));
  }
}
