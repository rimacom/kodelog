import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:denikprogramatora/okna/app.dart';
import 'package:denikprogramatora/okna/settings.dart';
import 'package:denikprogramatora/okna/signin_page.dart';
import 'package:denikprogramatora/utils/devicecontainer.dart';
import 'package:denikprogramatora/utils/input_decoration.dart';
import 'package:denikprogramatora/utils/loading_widget.dart';
import 'package:denikprogramatora/utils/months.dart';
import 'package:denikprogramatora/utils/my_category.dart';
import 'package:denikprogramatora/utils/my_container.dart';
import 'package:denikprogramatora/utils/new_record_dialog.dart';
import 'package:denikprogramatora/utils/programmer.dart';
import 'package:denikprogramatora/utils/show_info_dialog.dart';
import 'package:denikprogramatora/utils/vzhled.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class AllRecordsPage extends StatefulWidget {
  const AllRecordsPage({super.key});

  @override
  State<AllRecordsPage> createState() => _AllRecordsPageState();
}

class _AllRecordsPageState extends State<AllRecordsPage> {
  bool _loading = true;
  Month mesic = months[0];
  int selectedDay = DateTime.now().day;
  int year = DateTime.now().year;

  List<MyCategory> categories = [MyCategory("Nic", "nic")];
  List<Programmer> programmers = [
    const Programmer("Nic", "nic"),
    Programmer(name, userUid)
  ];
  List filterJazyky = [
    {"jazyk": "Nic", "barva": 0xff8200f3},
  ];

  late String selectedCategory;
  late String selectedProgrammer;
  bool newestToOldest = true;
  late String selectedJazyk;
  DateTime fromDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime toDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  bool searchByFromDate = false;
  bool searchByToDate = false;

  int timeHour = 0;
  int timeMinute = 0;
  int review = 0;

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

    name = FirebaseAuth.instance.currentUser!.displayName!;

    ref.collection("programmers").get().then((value) {
      for (var snap in value.docs) {
        var data = snap.data();

        programmers.add(Programmer(data["name"], snap.id));
      }
    });

    ref.collection("categories").get().then((value) {
      for (var snap in value.docs) {
        var data = snap.data();
        categories.add(MyCategory(data["name"], snap.id));
      }
    });

    filterJazyky.addAll(jazyky);

    selectedCategory = categories[0].id;
    selectedProgrammer = programmers[0].id;
    selectedJazyk = "Nic";

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
                        mainAxisAlignment: MainAxisAlignment.center,
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
                                        // ignore: use_build_context_synchronously
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
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const HlavniOkno()));
                                      },
                                      child: const Text(
                                        "Denní přehled",
                                        style:
                                            TextStyle(color: Vzhled.textColor),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    TextButton(
                                      onPressed: () {},
                                      child: const Text(
                                        "Všechny\nzáznamy",
                                        style: TextStyle(
                                          color: Vzhled.textColor,
                                          fontWeight: FontWeight.bold,
                                        ),
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
                                    width:
                                        (Device.screenType == ScreenType.mobile)
                                            ? 80.w
                                            : 40.w,
                                    child: Column(
                                      children: [
                                        const Text("Filtr",
                                            style: Vzhled.nadpis),
                                        const SizedBox(height: 15),
                                        Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                                  "Záznamy seřazené od ${newestToOldest ? "nejnovějších po nejstarší" : "nejstarších po nejnovější"}"),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  newestToOldest =
                                                      !newestToOldest;
                                                });
                                              },
                                              child: const Text(
                                                "Změnit",
                                                style: Vzhled.textBtn,
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 15),
                                        DeviceContainer(
                                          children: [
                                            const Text("Kategorie"),
                                            const SizedBox(width: 15),
                                            DropdownButton(
                                              value: selectedCategory,
                                              items: categories.map((e) {
                                                return DropdownMenuItem(
                                                    value: e.id,
                                                    child: Text(e.name));
                                              }).toList(),
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedCategory = value!;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 15),
                                        DeviceContainer(
                                          children: [
                                            const Text("Jazyk"),
                                            const SizedBox(width: 15),
                                            DropdownButton(
                                              value: selectedJazyk,
                                              dropdownColor:
                                                  Vzhled.backgroundColor,
                                              items: filterJazyky
                                                  .map(
                                                    (e) => DropdownMenuItem(
                                                      value: e["jazyk"],
                                                      child: Text(e["jazyk"]),
                                                    ),
                                                  )
                                                  .toList(),
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedJazyk =
                                                      (value as String?)!;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 15),
                                        DeviceContainer(
                                          children: [
                                            const Text("Programátor"),
                                            const SizedBox(width: 15),
                                            DropdownButton(
                                              value: selectedProgrammer,
                                              items: programmers.map((e) {
                                                return DropdownMenuItem(
                                                    value: e.id,
                                                    child: Text(e.name));
                                              }).toList(),
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedProgrammer = value!;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 15),
                                        DeviceContainer(
                                          children: [
                                            const Text("Strávený čas"),
                                            const SizedBox(width: 15),
                                            SizedBox(
                                              width: 75,
                                              child: TextField(
                                                decoration:
                                                    inputDecoration("Hodin"),
                                                onChanged: (value) {
                                                  setState(() {
                                                    timeHour =
                                                        value.trim().isEmpty
                                                            ? 0
                                                            : int.parse(value);
                                                  });
                                                },
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: <
                                                    TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .digitsOnly
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 15),
                                            SizedBox(
                                              width: 75,
                                              child: TextField(
                                                decoration:
                                                    inputDecoration("Minut"),
                                                onChanged: (value) {
                                                  setState(() {
                                                    timeMinute =
                                                        value.trim().isEmpty
                                                            ? 0
                                                            : int.parse(value);
                                                  });
                                                },
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: <
                                                    TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .digitsOnly
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 15),
                                            if (timeMinute != 0 ||
                                                timeHour != 0)
                                              TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    timeMinute = 0;
                                                    timeHour = 0;
                                                  });
                                                },
                                                child: const Text(
                                                  "Zrušit filtr",
                                                  style: Vzhled.textBtn,
                                                ),
                                              )
                                          ],
                                        ),
                                        const SizedBox(height: 15),
                                        DeviceContainer(
                                          children: [
                                            const Text("Hodnocení"),
                                            const SizedBox(width: 15),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: List.generate(
                                                5,
                                                (index) {
                                                  return IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        review = index + 1;
                                                      });
                                                    },
                                                    icon: Icon(Icons.star,
                                                        color: (index + 1) <=
                                                                review
                                                            ? Colors.yellow
                                                            : Colors.grey),
                                                  );
                                                },
                                              ),
                                            ),
                                            if (review != 0)
                                              TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    review = 0;
                                                  });
                                                },
                                                child: const Text(
                                                  "Zrušit filtr",
                                                  style: Vzhled.textBtn,
                                                ),
                                              )
                                          ],
                                        ),
                                        const SizedBox(height: 15),
                                        Row(
                                          children: [
                                            const Text("Od: "),
                                            const SizedBox(width: 15),
                                            TextButton(
                                              onPressed: () {
                                                showDatePicker(
                                                        context: context,
                                                        initialDate: fromDate,
                                                        firstDate: DateTime(
                                                            DateTime.now()
                                                                    .year -
                                                                5),
                                                        lastDate: DateTime(
                                                            DateTime.now()
                                                                    .year +
                                                                5))
                                                    .then((value) {
                                                  setState(() {
                                                    fromDate = value!;
                                                    searchByFromDate = true;
                                                  });
                                                }).onError(
                                                        (error, stackTrace) =>
                                                            null);
                                              },
                                              child: Text(searchByFromDate
                                                  ? "${fromDate.day}.${fromDate.month}.${fromDate.year}"
                                                  : "Vybrat den"),
                                            ),
                                            const SizedBox(width: 15),
                                            if (searchByFromDate)
                                              TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    searchByFromDate = false;
                                                  });
                                                },
                                                child: const Text(
                                                  ("Zrušit filtr"),
                                                  style: Vzhled.textBtn,
                                                ),
                                              ),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          children: [
                                            const Text("Do: "),
                                            const SizedBox(width: 15),
                                            TextButton(
                                              onPressed: () {
                                                showDatePicker(
                                                        context: context,
                                                        initialDate: toDate,
                                                        firstDate: DateTime(
                                                            DateTime.now()
                                                                    .year -
                                                                5),
                                                        lastDate: DateTime(
                                                            DateTime.now()
                                                                    .year +
                                                                5))
                                                    .then((value) {
                                                  setState(() {
                                                    toDate = value!;
                                                    searchByToDate = true;
                                                  });
                                                }).onError(
                                                        (error, stackTrace) =>
                                                            null);
                                              },
                                              child: Text(searchByToDate
                                                  ? "${toDate.day}.${toDate.month}.${toDate.year}"
                                                  : "Vybrat den"),
                                            ),
                                            const SizedBox(width: 15),
                                            if (searchByToDate)
                                              TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    searchByToDate = false;
                                                  });
                                                },
                                                child: const Text(
                                                  ("Zrušit filtr"),
                                                  style: Vzhled.textBtn,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        (Device.screenType == ScreenType.mobile)
                                            ? 80.w
                                            : 40.w,
                                    child: StreamBuilder(
                                      stream: ref
                                          .collection("records")
                                          .orderBy("fromDate",
                                              descending: newestToOldest)
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          var docs = snapshot.data!.docs;

                                          if (selectedProgrammer != "nic") {
                                            docs = docs
                                                .where((element) =>
                                                    element
                                                        .data()["programmer"] ==
                                                    selectedProgrammer)
                                                .toList();
                                          }

                                          if (selectedCategory != "nic") {
                                            docs = docs
                                                .where((element) => (element
                                                            .data()[
                                                        "categories"] as List)
                                                    .contains(selectedCategory))
                                                .toList();
                                          }

                                          if (selectedJazyk != "Nic") {
                                            docs = docs
                                                .where((element) =>
                                                    element.data()["language"]
                                                        ["jazyk"] ==
                                                    selectedJazyk)
                                                .toList();
                                          }

                                          if (searchByFromDate) {
                                            docs = docs
                                                .where((d) =>
                                                    (d.data()["fromDate"]
                                                                as Timestamp)
                                                            .toDate()
                                                            .compareTo(
                                                                fromDate) ==
                                                        1 ||
                                                    (d.data()["fromDate"]
                                                                as Timestamp)
                                                            .toDate()
                                                            .compareTo(
                                                                fromDate) ==
                                                        0)
                                                .toList();
                                          }

                                          if (searchByToDate) {
                                            docs = docs
                                                .where((d) =>
                                                    (d.data()["toDate"]
                                                                as Timestamp)
                                                            .toDate()
                                                            .compareTo(
                                                                toDate) ==
                                                        -1 ||
                                                    (d.data()["toDate"]
                                                                as Timestamp)
                                                            .toDate()
                                                            .compareTo(
                                                                toDate) ==
                                                        0)
                                                .toList();
                                          }

                                          if (timeHour != 0 ||
                                              timeMinute != 0) {
                                            if (kDebugMode) {
                                              print(
                                                  "${timeHour == 0 ? "" : (timeHour == 1 ? "$timeHour hodina" : "$timeHour hodin")}${timeMinute == 0 ? "" : (timeMinute == 1 ? "a $timeMinute minuta" : " a $timeMinute minut")}");
                                            }
                                            docs = docs
                                                .where((element) => (element
                                                        .data()["codingTime"] ==
                                                    "${timeHour == 0 ? "" : (timeHour == 1 ? "$timeHour hodina" : "$timeHour hodin")}${timeMinute == 0 ? "" : (timeMinute == 1 ? "a $timeMinute minuta" : " a $timeMinute minut")}"))
                                                .toList();
                                          }

                                          if (review != 0) {
                                            docs = docs
                                                .where((element) =>
                                                    element.data()["review"] ==
                                                    review)
                                                .toList();
                                          }

                                          return Column(
                                            children: List.generate(
                                              docs.length,
                                              (index) {
                                                var data = docs[index].data();

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
                                                      color: Color(
                                                          data["language"]
                                                              ["barva"]),
                                                    ),
                                                    child: Material(
                                                      color: Colors.transparent,
                                                      child: InkWell(
                                                        onTap: () =>
                                                            showInfoDialog(
                                                                context,
                                                                data,
                                                                docs[index].id),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                  "${(data["fromDate"] as Timestamp).toDate().year}.${(data["fromDate"] as Timestamp).toDate().month}.${(data["fromDate"] as Timestamp).toDate().day} ${(data["fromDate"] as Timestamp).toDate().hour < 10 ? "0${(data["fromDate"] as Timestamp).toDate().hour}" : (data["fromDate"] as Timestamp).toDate().hour}:${(data["fromDate"] as Timestamp).toDate().minute < 10 ? "0${(data["fromDate"] as Timestamp).toDate().minute}" : (data["fromDate"] as Timestamp).toDate().minute}"),
                                                              const SizedBox(
                                                                width: 20,
                                                              ),
                                                              Text(
                                                                  " - ${data["language"]["jazyk"]}")
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
}
