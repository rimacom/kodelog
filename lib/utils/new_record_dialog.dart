import 'package:denikprogramatora/okna/app.dart';
import 'package:denikprogramatora/utils/datum_cas.dart';
import 'package:denikprogramatora/utils/devicecontainer.dart';
import 'package:denikprogramatora/utils/dokument.dart';
import 'package:denikprogramatora/utils/loading_widget.dart';
import 'package:denikprogramatora/utils/programmer.dart';
import 'package:denikprogramatora/utils/really_delete.dart';
import 'package:denikprogramatora/utils/vzhled.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:uuid/uuid.dart';

import '../utils/my_category.dart';

Future<void> showCreateItemDialog(context,
    {DateTime? originDate,
    Duration? timeSpent,
    String? j,
    int hvezdicky = 0,
    String? p,
    List<MyCategory>? k,
    String? originalId,
    ParchmentDocument? doc}) async {
  DateTime date = originDate ??
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
          DateTime.now().hour - 1);

  // nastavení jazyka na oblíbený jazyk
  String jazyk = "C#";
  if (j == null) {
    await ref.get().then((value) {
      jazyk = value["favourite"] ?? "Dart";
    });
  } else {
    jazyk = j;
  }

  timeSpent = timeSpent ?? const Duration(hours: 0, minutes: 0);

  int review = hvezdicky;

  Programmer programmer = Programmer(name, "pK8iCAtMFiUUhK9FJd6HpWdwA3I3");

  List<MyCategory> categories = k ?? [];

  FleatherController controller =
      doc == null ? FleatherController() : FleatherController(doc);

  await showDialog(
    context: context,
    builder: (_) => AlertDialog(
      scrollable: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(doc == null ? "Nový záznam" : "Úprava záznamu",
          style: Vzhled.velkyText),
      content: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            children: [
              DeviceContainer(
                mainAxisAlignmentDesktop: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width:
                        (Device.screenType == ScreenType.mobile) ? 80.w : 40.w,
                    child: Column(
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Datum a čas",
                            style: Vzhled.nadpis,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Text(
                                "Datum ${date.day}. ${date.month}. ${date.year}"),
                            const SizedBox(width: 15),
                            TextButton(
                              onPressed: () {
                                showDatePicker(
                                        context: context,
                                        initialDate: date,
                                        firstDate:
                                            DateTime(DateTime.now().year - 5),
                                        lastDate:
                                            DateTime(DateTime.now().year + 5))
                                    .then((value) {
                                  setState(() {
                                    date = DateTime(
                                      value!.year,
                                      value.month,
                                      value.day,
                                    );
                                  });
                                });
                              },
                              child: const Text(
                                "Změnit",
                                style: Vzhled.textBtn,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 30),
                        Row(
                          children: [
                            Text(
                                "Strávený čas ${timeSpent!.inHours} hodin ${timeSpent!.inMinutes - timeSpent!.inHours * 60} minut"),
                            const SizedBox(width: 15),
                            TextButton(
                              onPressed: () async {
                                await showDurationPicker(
                                        context: context,
                                        baseUnit: BaseUnit.hour,
                                        initialTime:
                                            timeSpent ?? const Duration())
                                    .then((hours) {
                                  showDurationPicker(
                                          context: context,
                                          baseUnit: BaseUnit.minute,
                                          initialTime: Duration(
                                              minutes: (timeSpent ??
                                                          const Duration())
                                                      .inMinutes -
                                                  (timeSpent ??
                                                              const Duration())
                                                          .inHours *
                                                      60))
                                      .then((minutes) => setState(() {
                                            timeSpent = Duration(
                                                hours: hours!.inHours,
                                                minutes: minutes!.inMinutes);
                                          }));
                                });
                              },
                              child: const Text(
                                "Změnit",
                                style: Vzhled.textBtn,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width:
                        (Device.screenType == ScreenType.mobile) ? 80.w : 40.w,
                    child: Column(
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Programovací jazyk",
                            style: Vzhled.nadpis,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: DropdownButton(
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
                        ),
                        const SizedBox(height: 30),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Hodnocení",
                            style: Vzhled.nadpis,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
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
                                      color: (index + 1) <= review
                                          ? Colors.yellow
                                          : Colors.grey),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              const Text(
                                "Kategorie",
                                style: Vzhled.nadpis,
                              ),
                              const SizedBox(width: 15),
                              TextButton(
                                onPressed: () async {
                                  List<MyCategory> newCategories =
                                      await showCategoriesDialog(
                                          context, categories);
                                  setState(() {
                                    categories = newCategories;
                                  });
                                },
                                child: const Text(
                                  "Vybrat",
                                  style: Vzhled.textBtn,
                                ),
                              )
                            ],
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
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: Adaptive.h(35),
                width: Adaptive.w(100),
                child: Column(
                  children: [
                    FleatherToolbar.basic(
                        controller: controller, hideHorizontalRule: true),
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
                          child: FleatherEditor(controller: controller),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              OutlinedButton(
                style: Vzhled.orangeCudlik,
                onPressed: () {
                  if (originalId == null) {
                    ref.collection("records").add({
                      "date": DateTime(date.year, date.month, date.day),
                      "time_spent": timeSpent!.durationText,
                      "time_spentRaw": timeSpent!.inSeconds,
                      "programmer": programmer.id,
                      "programming_language": jazyky
                          .where((element) => element["jazyk"] == jazyk)
                          .toList()[0],
                      "rating": review,
                      "categories": categories.map((e) => e.id).toList(),
                      "description": controller.document.toActualJson(),
                      "descriptionRaw": controller.document.toPlainText()
                    }).then((value) =>
                        Navigator.of(context, rootNavigator: true)
                            .pop("dialog"));
                    return;
                  }
                  ref.collection("records").doc(originalId).update({
                    "date": DateTime(date.year, date.month, date.day),
                    "time_spentRaw": timeSpent!.inSeconds,
                    "time_spent": timeSpent!.durationText,
                    "programmer": programmer.id,
                    "programming_language": jazyky
                        .where((element) => element["jazyk"] == jazyk)
                        .toList()[0],
                    "rating": review,
                    "categories": categories.map((e) => e.id).toList(),
                    "descriptionRaw": controller.document.toPlainText(),
                    "description": controller.document.toActualJson(),
                  }).then((value) =>
                      Navigator.of(context, rootNavigator: true).pop("dialog"));
                },
                child: Text(
                  (originalId == null) ? "Vytvořit" : "Změnit",
                  style: const TextStyle(
                    fontSize: Vzhled.text,
                  ),
                ),
              )
            ],
          );
        },
      ),
    ),
  );
}

Future<List<MyCategory>> showCategoriesDialog(
    context, List<MyCategory> categories,
    {bool jenMenit = false}) async {
  bool showCategoryEdit = false;
  bool editing = false;
  GlobalKey<FormState> key = GlobalKey<FormState>();
  TextEditingController nameCon = TextEditingController();
  int color = 0;
  String editId = "";

  Map selected = {};

  // fetching data for all categories and setting selected to false
  await ref.collection("categories").get().then((value) {
    for (var snap in value.docs) {
      selected[snap.id] = false;
    }
  });

  // already selected categories setting to true
  for (var snap in categories) {
    selected[snap.id] = true;
  }

  await showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Kategorie", style: Vzhled.velkyText),
      scrollable: true,
      content: SizedBox(
        width: 50.w,
        child: StatefulBuilder(
          builder: (context, setState) {
            return showCategoryEdit
                ? Form(
                    key: key,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: nameCon,
                                decoration: Vzhled.inputDecoration("Název"),
                                validator: (value) {
                                  if (value!.trim().isEmpty) {
                                    return "Toto pole je povinné!";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 5),
                            TextButton(
                              onPressed: () {
                                if (key.currentState!.validate()) {
                                  if (editing) {
                                    ref
                                        .collection("categories")
                                        .doc(editId)
                                        .update({
                                      "name": nameCon.text,
                                      "color": color,
                                    });
                                  } else {
                                    var uuid = const Uuid();
                                    String id = uuid.v1();

                                    ref.collection("categories").doc(id).set({
                                      "name": nameCon.text,
                                      "id": id,
                                      "color": color
                                    });

                                    selected[id] = false;
                                  }

                                  nameCon.text = "";

                                  setState(() {
                                    showCategoryEdit = false;
                                    editing = false;
                                  });
                                }
                              },
                              child: Text(
                                editing ? "Uložit" : "Přidat",
                                style: Vzhled.textBtn,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              showCategoryEdit = false;
                            });
                          },
                          child: const Text(
                            "Zpátky",
                            style: Vzhled.textBtn,
                          ),
                        ),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      StreamBuilder(
                          stream: ref.collection("categories").snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              var docs = snapshot.data!.docs;

                              return Column(
                                children: List.generate(docs.length, (index) {
                                  var data = docs[index].data();

                                  return Material(
                                    color: Vzhled.dialogColor,
                                    child: InkWell(
                                      splashColor: (jenMenit)
                                          ? Colors.transparent
                                          : null,
                                      onTap: (() {
                                        if (jenMenit) return;
                                        setState(
                                          () {
                                            selected[data["id"]] =
                                                !selected[data["id"]];
                                          },
                                        );
                                      }),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(data["name"]),
                                            (selected[data["id"]])
                                                ? TextButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        selected[data["id"]] =
                                                            false;
                                                      });
                                                    },
                                                    child: const Text(
                                                      "Odebrat",
                                                      style: Vzhled.textBtn,
                                                    ),
                                                  )
                                                : Row(
                                                    children: [
                                                      if (!jenMenit)
                                                        TextButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              selected[data[
                                                                  "id"]] = true;
                                                            });
                                                          },
                                                          child: const Text(
                                                            "Vybrat",
                                                            style:
                                                                Vzhled.textBtn,
                                                          ),
                                                        ),
                                                      IconButton(
                                                        onPressed: () {
                                                          editId = data["id"];

                                                          setState(() {
                                                            showCategoryEdit =
                                                                true;
                                                            editing = true;
                                                            nameCon =
                                                                TextEditingController(
                                                                    text: data[
                                                                        "name"]);
                                                          });
                                                        },
                                                        icon: const Icon(
                                                            Icons.edit,
                                                            color: Vzhled
                                                                .textColor,
                                                            size: 18),
                                                      ),
                                                      IconButton(
                                                        onPressed: () {
                                                          showReallyDelete(
                                                              context, () {
                                                            Navigator.of(
                                                                    context,
                                                                    rootNavigator:
                                                                        true)
                                                                .pop("dialog");

                                                            ref
                                                                .collection(
                                                                    "categories")
                                                                .doc(data["id"])
                                                                .delete();
                                                          },
                                                              doNavigatorPop:
                                                                  false);
                                                        },
                                                        icon: const Icon(
                                                            Icons.delete,
                                                            color: Vzhled
                                                                .textColor,
                                                            size: 18),
                                                      )
                                                    ],
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              );
                            }
                            return const LoadingWidget();
                          }),
                      const SizedBox(height: 5),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            showCategoryEdit = true;
                          });
                        },
                        child: const Text(
                          "Nová kategorie",
                          style: Vzhled.textBtn,
                        ),
                      ),
                    ],
                  );
          },
        ),
      ),
    ),
  );

  // creating new list
  categories = [];
  await ref.collection("categories").get().then(
    (value) {
      var docs = value.docs;
      for (var snap in docs) {
        if (selected[snap.id]) {
          var data = snap.data();
          categories.add(MyCategory(data["name"], snap.id));
        }
      }
    },
  );

  // popravde som prave napisal totalne shitny kod, ale nemam najmensiu chybu hladata lepsie riesenie. ak toto citas kludne to cele prepis a odstran

  return categories;
}
