import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:denikprogramatora/okna/app.dart';
import 'package:denikprogramatora/okna/settings.dart';
import 'package:denikprogramatora/okna/signin_page.dart';
import 'package:denikprogramatora/utils/datum_cas.dart';
import 'package:denikprogramatora/utils/devicecontainer.dart';
import 'package:denikprogramatora/utils/loading_widget.dart';
import 'package:denikprogramatora/utils/months.dart';
import 'package:denikprogramatora/utils/my_container.dart';
import 'package:denikprogramatora/utils/new_record_dialog.dart';
import 'package:denikprogramatora/utils/show_info_dialog.dart';
import 'package:denikprogramatora/utils/vzhled.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher_string.dart';

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

  bool newestToOldest = true;

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
                              child: Center(
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                            "Záznamy seřazené \nod ${newestToOldest ? "nejnovějších po nejstarší" : "nejstarších po nejnovější"}"),
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              newestToOldest = !newestToOldest;
                                            });
                                          },
                                          child: const Text(
                                            "Změnit",
                                            style: Vzhled.textBtn,
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    SizedBox(
                                      width: (Device.screenType ==
                                              ScreenType.mobile)
                                          ? 80.w
                                          : 40.w,
                                      child: StreamBuilder(
                                        stream: ref
                                            .collection("records")
                                            .orderBy("date",
                                                descending: newestToOldest)
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            var docs = snapshot.data!.docs;

                                            return Column(
                                              children: List.generate(
                                                docs.length,
                                                (index) {
                                                  var data = docs[index].data();

                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
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
                                                        color:
                                                            Colors.transparent,
                                                        child: InkWell(
                                                          onTap: () =>
                                                              showInfoDialog(
                                                                  context,
                                                                  data,
                                                                  docs[index]
                                                                      .id,
                                                                  name),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Row(
                                                              children: [
                                                                Text((data["date"]
                                                                        as Timestamp)
                                                                    .toDate()
                                                                    .dateString),
                                                                const SizedBox(
                                                                  width: 20,
                                                                ),
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
                                  ],
                                ),
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
