import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:denikprogramatora/okna/app.dart';
import 'package:denikprogramatora/utils/datum_cas.dart';
import 'package:denikprogramatora/utils/devicecontainer.dart';
import 'package:denikprogramatora/utils/my_category.dart';
import 'package:denikprogramatora/utils/new_record_dialog.dart';
import 'package:denikprogramatora/utils/really_delete.dart';
import 'package:denikprogramatora/utils/vzhled.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void showInfoDialog(
    context, Map<String, dynamic> data, String originalId, String jmeno) async {
  var date = (data["date"] as Timestamp).toDate().toLocal();
  List<MyCategory> categories = [];

  if (((data["categories"] ?? []) as List).isNotEmpty) {
    for (var category in data["categories"]) {
      await ref.collection("categories").doc(category).get().then((value) {
        var data = value.data();

        categories.add(MyCategory(data!["name"], category));
      }).onError((error, stackTrace) => null);
    }
  }

  showDialog(
    context: context,
    builder: (_) {
      var document = (data["description"] != null && data["description"] != "")
          ? ParchmentDocument.fromJson(data["description"])
          : (ParchmentDocument()..insert(0, data["descriptionRaw"]));
      var controller = FleatherController(document);

      return AlertDialog(
        actions: [
          TextButton(
              onPressed: () => showReallyDelete(
                  context,
                  () => FirebaseFirestore.instance
                      .collection("users")
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection("records")
                      .doc(originalId)
                      .delete()
                      .then((_) => Navigator.of(context).pop())),
              style: Vzhled.orangeCudlik,
              child: const Text("Smazat")),
          TextButton(
              style: Vzhled.purpleCudlik,
              onPressed: () {
                showCreateItemDialog(context,
                        originDate: date,
                        timeSpent: Duration(seconds: data["time_spentRaw"]),
                        k: categories,
                        p: data["programmer"],
                        hvezdicky: data["rating"],
                        originalId: originalId,
                        j: data["programming_language"]["jazyk"],
                        doc: document)
                    .then((_) => Navigator.of(context).pop());
              },
              child: const Text("Upravit")),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: Vzhled.purpleCudlik,
            child: const Text("Zavřít"),
          ),
        ],
        title: Text(
          "Záznam ze dne ${date.dateString}",
          style: Vzhled.dialogNadpis,
        ),
        scrollable: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: SizedBox(
          height: 60.h,
          width: 90.w,
          child: SingleChildScrollView(
            child: Column(
              children: [
                DeviceContainer(
                  children: [
                    SizedBox(
                      width: (Device.screenType == ScreenType.mobile)
                          ? 80.w
                          : 40.w,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Text(
                                "Datum: ",
                                style: Vzhled.nadpis,
                              ),
                              Text(
                                "${date.dateString} (${data["time_spent"]})",
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              const Text(
                                "Jazyk: ",
                                style: Vzhled.nadpis,
                              ),
                              Text(
                                data["programming_language"]["jazyk"],
                                style: TextStyle(
                                    color: Color(
                                        data["programming_language"]["barva"])),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: (Device.screenType == ScreenType.mobile)
                          ? 80.w
                          : 40.w,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Text(
                                "Programátor: ",
                                style: Vzhled.nadpis,
                              ),
                              Text(
                                FirebaseAuth
                                        .instance.currentUser!.displayName ??
                                    jmeno,
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              const Text(
                                "Hodnocení: ",
                                style: Vzhled.nadpis,
                              ),
                              Row(
                                children: List.generate(
                                  5,
                                  (index) {
                                    return Icon(Icons.star,
                                        color: (index + 1) <= data["rating"]
                                            ? Colors.yellow
                                            : Colors.grey);
                                  },
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                if (categories.isNotEmpty)
                  Column(
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Kategorie",
                          style: Vzhled.nadpis,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: List.generate(
                          categories.length,
                          (index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(categories[index].name),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                SizedBox(
                  height: Adaptive.h(35),
                  width: Adaptive.w(100),
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FleatherEditor(
                                readOnly: true, controller: controller),
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
    },
  );
}
