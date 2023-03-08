import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:denikprogramatora/okna/all_records.dart';
import 'package:denikprogramatora/okna/settings.dart';
import 'package:denikprogramatora/okna/signin_page.dart';
import 'package:denikprogramatora/utils/devicecontainer.dart';
import 'package:denikprogramatora/utils/loading_widget.dart';
import 'package:denikprogramatora/utils/months.dart';
import 'package:denikprogramatora/utils/my_container.dart';
import 'package:denikprogramatora/utils/new_record_dialog.dart';
import 'package:denikprogramatora/utils/vzhled.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../utils/razeni.dart';
import '../utils/show_info_dialog.dart';

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

var ref = FirebaseFirestore.instance
    .collection("users")
    .doc(FirebaseAuth.instance.currentUser!.uid);
String name = "error";
String userUid = "error";

class HlavniOkno extends StatefulWidget {
  const HlavniOkno({super.key});

  @override
  State<HlavniOkno> createState() => _HlavniOknoState();
}

class _HlavniOknoState extends State<HlavniOkno> {
  bool _loading = true;

  Month mesic = months[0];
  int selectedDay = DateTime.now().day;
  int year = DateTime.now().year;
  int vybraneRazeni = 0;

  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser == null) {
      if (kDebugMode) print("user should not be here");
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (c) => const SignInPage()),
          (route) => false);
      return;
    }
    userUid = FirebaseAuth.instance.currentUser!.uid;

    ref.get().then((value) {
      setState(() {
        name = FirebaseAuth.instance.currentUser!.displayName ??
            value[
                "name"]; // fallback když uživatel je vytvořen skrz firebase admin
      });
    });
    mesic = months[DateTime.now().month - 1];

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 90.w,
          child: (_loading)
              ? const LoadingWidget()
              : CustomScrollView(
                  slivers: [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Column(
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    if (name != "error") Text("Ahoj $name"),
                                    TextButton(
                                      onPressed: () => showAboutDialog(
                                          context: context,
                                          applicationName: "Kodelog",
                                          applicationVersion: "2.0.1",
                                          applicationLegalese:
                                              "©️ 2023 Matyáš Caras a Richard Pavlikán" /*+",\n vydáno pod licencí AGPLv3"*/,
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
                                                builder: (c) =>
                                                    const SignInPage()),
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
                                      onPressed: () {},
                                      child: const Text(
                                        "Denní přehled",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Vzhled.textColor),
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
                                        style:
                                            TextStyle(color: Vzhled.textColor),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const NastaveniOkno()));
                                      },
                                      child: const Text(
                                        "Nastavení",
                                        style:
                                            TextStyle(color: Vzhled.textColor),
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
                              child: DeviceContainer(
                                mainAxisAlignmentDesktop:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 40.w,
                                    child: StreamBuilder(
                                      stream:
                                          ref.collection("records").snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          var docs = snapshot.data!.docs;
                                          var jenMesic = docs
                                              .where((d) => DateTime.parse(
                                                      "$year-${(mesic.position + 1 < 10) ? "0${mesic.position + 1}" : mesic.position + 1}-${selectedDay < 10 ? "0$selectedDay" : selectedDay} 00:00:00")
                                                  .isAtSameMomentAs(
                                                      (d.data()["date"]
                                                              as Timestamp)
                                                          .toDate()))
                                              .toList() // vybere pouze záznamy, které probíhají ve vybraný den
                                            ..sort(
                                              razeni[vybraneRazeni],
                                            ); // seřadíme podle vybrané metody řazení
                                          if (jenMesic.isEmpty) {
                                            return const Text(
                                              "Nic",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 25),
                                            );
                                          }

                                          return Column(
                                            children: List.generate(
                                              jenMesic.length,
                                              (index) {
                                                var data =
                                                    jenMesic[index].data();

                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                        Radius.circular(4),
                                                      ),
                                                      color: Color(data[
                                                              "programming_language"]
                                                          ["barva"]),
                                                    ),
                                                    child: Material(
                                                      color: Colors.transparent,
                                                      child: InkWell(
                                                        onTap: () =>
                                                            showInfoDialog(
                                                                context,
                                                                data,
                                                                jenMesic[index]
                                                                    .id,
                                                                name),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                "${data["programming_language"]["jazyk"]}",
                                                                style: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              Text(
                                                                  " - ${data["time_spent"]}")
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        }
                                        return const LoadingWidget();
                                      },
                                    ),
                                  ),
                                  if (Device.screenType == ScreenType.mobile)
                                    const SizedBox(
                                      height: 50,
                                    ),
                                  SizedBox(
                                    width:
                                        (Device.screenType == ScreenType.mobile)
                                            ? 60.w
                                            : 40.w,
                                    child: Column(
                                      children: [
                                        DeviceContainer(
                                          mainAxisAlignmentDesktop:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            const Text("Řazení:"),
                                            DropdownButton(
                                              items: const [
                                                DropdownMenuItem<int>(
                                                  value: 0,
                                                  child: Text(
                                                      "Vzestupně dle času"),
                                                ),
                                                DropdownMenuItem<int>(
                                                  value: 1,
                                                  child:
                                                      Text("Sestupně dle času"),
                                                ),
                                                DropdownMenuItem<int>(
                                                  value: 2,
                                                  child: Text(
                                                      "Vzestupně dle hodnocení"),
                                                ),
                                                DropdownMenuItem<int>(
                                                  value: 3,
                                                  child: Text(
                                                      "Sestupně dle hodnocení"),
                                                ),
                                              ],
                                              value: vybraneRazeni,
                                              onChanged: (v) {
                                                if (v == null) return;

                                                vybraneRazeni = v;
                                                setState(() {});
                                              },
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 30),
                                        if (Device.screenType !=
                                            ScreenType.mobile)
                                          Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  IconButton(
                                                    onPressed: () {
                                                      setState(
                                                        () {
                                                          if (mesic.position -
                                                                  1 !=
                                                              -1) {
                                                            mesic = months[
                                                                mesic.position -
                                                                    1];
                                                          } else {
                                                            mesic = months[11];
                                                            year--;
                                                          }
                                                        },
                                                      );
                                                    },
                                                    icon: const Icon(
                                                        Icons.arrow_back,
                                                        color: Vzhled.purple),
                                                  ),
                                                  SizedBox(
                                                    width: 150,
                                                    child: Center(
                                                      child: Text(
                                                        "${mesic.name} $year",
                                                        style: Vzhled.velkyText,
                                                      ),
                                                    ),
                                                  ),
                                                  IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        if (mesic.position +
                                                                1 !=
                                                            12) {
                                                          mesic = months[
                                                              mesic.position +
                                                                  1];
                                                        } else {
                                                          mesic = months[0];
                                                          year++;
                                                        }
                                                      });
                                                    },
                                                    icon: const Icon(
                                                        Icons.arrow_forward,
                                                        color: Vzhled.purple),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 20),
                                              calendarView()
                                            ],
                                          )
                                      ],
                                    ),
                                  ),
                                  if (Device.screenType == ScreenType.mobile)
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                setState(
                                                  () {
                                                    if (mesic.position - 1 !=
                                                        -1) {
                                                      mesic = months[
                                                          mesic.position - 1];
                                                    } else {
                                                      mesic = months[11];
                                                      year--;
                                                    }
                                                  },
                                                );
                                              },
                                              icon: const Icon(Icons.arrow_back,
                                                  color: Vzhled.purple),
                                            ),
                                            SizedBox(
                                              width: 150,
                                              child: Center(
                                                child: Text(
                                                  "${mesic.name} $year",
                                                  style: Vzhled.velkyText,
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  if (mesic.position + 1 !=
                                                      12) {
                                                    mesic = months[
                                                        mesic.position + 1];
                                                  } else {
                                                    mesic = months[0];
                                                    year++;
                                                  }
                                                });
                                              },
                                              icon: const Icon(
                                                  Icons.arrow_forward,
                                                  color: Vzhled.purple),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        calendarView()
                                      ],
                                    )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }

  Widget calendarView() {
    int day = 1;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        ((mesic.days / 7) == 4
            ? (Device.screenType == ScreenType.mobile)
                ? 10
                : 4
            : (Device.screenType == ScreenType.mobile)
                ? 11
                : 5),
        (index) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            // (Device.screenType == ScreenType.mobile)
            //     ? MainAxisAlignment.center
            //     : MainAxisAlignment.start,
            children: List.generate(
              (Device.screenType == ScreenType.mobile) ? 3 : 7,
              (index) {
                int thisDay = day++;

                if (thisDay > mesic.days) {
                  return const SizedBox();
                }
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        selectedDay = thisDay;
                      });
                    },
                    style: OutlinedButton.styleFrom(
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        backgroundColor: (selectedDay == thisDay)
                            ? Vzhled.purple
                            : Colors.black.withOpacity(0),
                        foregroundColor: (selectedDay == thisDay)
                            ? Vzhled.backgroundColor
                            : Vzhled.textColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        side: BorderSide(
                            color: (selectedDay != thisDay)
                                ? Vzhled.purple
                                : Colors.black.withOpacity(0))),
                    child: Text(thisDay.toString()),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
