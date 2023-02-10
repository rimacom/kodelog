import 'package:denikprogramatora/okna/app.dart';
import 'package:denikprogramatora/utils/datum.dart';
import 'package:denikprogramatora/utils/devicecontainer.dart';
import 'package:denikprogramatora/utils/dokument.dart';
import 'package:denikprogramatora/utils/loading_widget.dart';
import 'package:denikprogramatora/utils/programmer.dart';
import 'package:denikprogramatora/utils/really_delete.dart';
import 'package:denikprogramatora/utils/vzhled.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:uuid/uuid.dart';

import '../utils/my_category.dart';

Future<void> showCreateItemDialog(context,
    {DateTime? from,
    DateTime? to,
    String? j,
    int hvezdicky = 0,
    String? p,
    List<MyCategory>? k,
    String? originalId,
    ParchmentDocument? doc}) async {
  DateTime fromDate = from ??
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
          DateTime.now().hour - 1);
  DateTime toDate = to ??
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
          DateTime.now().hour);

  // nastavení jazyka na oblíbený jazyk
  String jazyk = "C#";
  if (j == null) {
    await ref.get().then((value) {
      jazyk = value["favourite"];
    });
  } else {
    jazyk = j;
  }

  int review = hvezdicky;

  Programmer programmer = p == null
      ? Programmer(name, userUid)
      : await Programmer.ziskatProgramatora(
          FirebaseAuth.instance.currentUser!, p);

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
                            Text("Od ${toDate.dateTimeString}"),
                            const SizedBox(width: 15),
                            TextButton(
                              onPressed: () {
                                showDatePicker(
                                        context: context,
                                        initialDate: fromDate,
                                        firstDate:
                                            DateTime(DateTime.now().year - 5),
                                        lastDate:
                                            DateTime(DateTime.now().year + 5))
                                    .then((value) {
                                  showTimePicker(
                                          context: context,
                                          initialTime:
                                              TimeOfDay.fromDateTime(fromDate))
                                      .then((time) {
                                    if (value!.day == toDate.day &&
                                        value.month == toDate.month &&
                                        value.year == toDate.year &&
                                        (time!.hour > toDate.hour ||
                                            (time.hour <= toDate.hour &&
                                                time.minute > toDate.minute))) {
                                      return;
                                    }
                                    setState(() {
                                      fromDate = DateTime(
                                          value.year,
                                          value.month,
                                          value.day,
                                          time!.hour,
                                          time.minute);
                                    });
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
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Text("Do ${toDate.dateTimeString}"),
                            const SizedBox(width: 15),
                            TextButton(
                              onPressed: () {
                                showDatePicker(
                                        context: context,
                                        initialDate: toDate,
                                        firstDate:
                                            DateTime(DateTime.now().year - 5),
                                        lastDate:
                                            DateTime(DateTime.now().year + 5))
                                    .then((value) {
                                  showTimePicker(
                                          context: context,
                                          initialTime:
                                              TimeOfDay.fromDateTime(toDate))
                                      .then((time) {
                                    if (value!.day == fromDate.day &&
                                        value.month == fromDate.month &&
                                        value.year == fromDate.year &&
                                        (time!.hour < fromDate.hour ||
                                            (time.hour >= fromDate.hour &&
                                                time.minute <
                                                    fromDate.minute))) {
                                      return;
                                    }
                                    setState(() {
                                      toDate = DateTime(value.year, value.month,
                                          value.day, time!.hour, time.minute);
                                    });
                                  });
                                });
                              },
                              child: const Text(
                                ("Změnit"),
                                style: Vzhled.textBtn,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 30),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Strávený čas",
                            style: Vzhled.nadpis,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                              "${toDate.difference(fromDate).inHours} ${toDate.difference(fromDate).inHours == 1 ? "hodina" : toDate.difference(fromDate).inHours > 1 && toDate.difference(fromDate).inHours < 5 ? "hodiny" : "hodin"}${(toDate.difference(fromDate).inMinutes - toDate.difference(fromDate).inHours * 60 == 0) ? "" : " a ${(toDate.difference(fromDate).inMinutes - toDate.difference(fromDate).inHours * 60)} ${(toDate.difference(fromDate).inMinutes - toDate.difference(fromDate).inHours * 60) == 1 ? "minuta" : (toDate.difference(fromDate).inMinutes - toDate.difference(fromDate).inHours * 60) > 1 && (toDate.difference(fromDate).inMinutes - toDate.difference(fromDate).inHours * 60) < 5 ? "minuty" : "minut"}"}"),
                        ),
                        const SizedBox(height: 30),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Programátor",
                            style: Vzhled.nadpis,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            onPressed: () async {
                              await showProgrammersDialog(context, doc: doc)
                                  .then((value) {
                                setState(() {
                                  programmer = value;
                                });
                              });
                            },
                            child: Text(
                              programmer.name,
                              style: Vzhled.textBtn,
                            ),
                          ),
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
                      "fromDate": fromDate,
                      "toDate": toDate,
                      "codingTime":
                          "${toDate.difference(fromDate).inHours} ${toDate.difference(fromDate).inHours == 1 ? "hodina" : toDate.difference(fromDate).inHours > 1 && toDate.difference(fromDate).inHours < 5 ? "hodiny" : "hodin"}${(toDate.difference(fromDate).inMinutes - toDate.difference(fromDate).inHours * 60 == 0) ? "" : " a ${(toDate.difference(fromDate).inMinutes - toDate.difference(fromDate).inHours * 60)} ${(toDate.difference(fromDate).inMinutes - toDate.difference(fromDate).inHours * 60) == 1 ? "minuta" : (toDate.difference(fromDate).inMinutes - toDate.difference(fromDate).inHours * 60) > 1 && (toDate.difference(fromDate).inMinutes - toDate.difference(fromDate).inHours * 60) < 5 ? "minuty" : "minut"}"}",
                      "programmer": programmer.id,
                      "programmerName": programmer.name,
                      "language": jazyky
                          .where((element) => element["jazyk"] == jazyk)
                          .toList()[0],
                      "review": review,
                      "categories": categories.map((e) => e.id).toList(),
                      "description": controller.document.toActualJson(),
                    }).then((value) =>
                        Navigator.of(context, rootNavigator: true)
                            .pop("dialog"));
                    return;
                  }
                  ref.collection("records").doc(originalId).update({
                    "fromDate": fromDate,
                    "toDate": toDate,
                    "codingTime":
                        "${toDate.difference(fromDate).inHours} ${toDate.difference(fromDate).inHours == 1 ? "hodina" : toDate.difference(fromDate).inHours > 1 && toDate.difference(fromDate).inHours < 5 ? "hodiny" : "hodin"}${(toDate.difference(fromDate).inMinutes - toDate.difference(fromDate).inHours * 60 == 0) ? "" : " a ${(toDate.difference(fromDate).inMinutes - toDate.difference(fromDate).inHours * 60)} ${(toDate.difference(fromDate).inMinutes - toDate.difference(fromDate).inHours * 60) == 1 ? "minuta" : (toDate.difference(fromDate).inMinutes - toDate.difference(fromDate).inHours * 60) > 1 && (toDate.difference(fromDate).inMinutes - toDate.difference(fromDate).inHours * 60) < 5 ? "minuty" : "minut"}"}",
                    "programmer": programmer.id,
                    "programmerName": programmer.name,
                    "language": jazyky
                        .where((element) => element["jazyk"] == jazyk)
                        .toList()[0],
                    "review": review,
                    "categories": categories.map((e) => e.id).toList(),
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

Future<Programmer> showProgrammersDialog(context,
    {ParchmentDocument? doc, bool jenMenit = false}) async {
  bool showAddProgrammer = false;
  bool editing = false;
  GlobalKey<FormState> key = GlobalKey<FormState>();
  TextEditingController nameCon = TextEditingController();
  late String editId;

  Programmer programmer = Programmer(name, userUid);

  await showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Programátoři", style: Vzhled.velkyText),
      scrollable: true,
      content: SizedBox(
        width: 50.w,
        child: StatefulBuilder(
          builder: (context, setState) {
            return showAddProgrammer
                ? Form(
                    key: key,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: nameCon,
                                decoration: Vzhled.inputDecoration("Jméno"),
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
                                        .collection("programmers")
                                        .doc(editId)
                                        .update({"name": nameCon.text});
                                  } else {
                                    var uuid = const Uuid();
                                    String id = uuid.v1();

                                    ref
                                        .collection("programmers")
                                        .doc(id)
                                        .set({"name": nameCon.text, "id": id});
                                  }
                                  nameCon.text = "";

                                  setState(() {
                                    editing = false;
                                    showAddProgrammer = false;
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
                              showAddProgrammer = false;
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
                      Material(
                        color: Vzhled.dialogColor,
                        child: InkWell(
                          splashColor: (jenMenit) ? Colors.transparent : null,
                          onTap: () {
                            if (jenMenit) return;
                            programmer = Programmer(name, userUid);
                            Navigator.of(context, rootNavigator: true)
                                .pop("dialog");
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(name),
                                if (!jenMenit)
                                  TextButton(
                                    onPressed: () {
                                      programmer = Programmer(name, userUid);
                                      Navigator.of(context, rootNavigator: true)
                                          .pop("dialog");
                                    },
                                    child: const Text(
                                      "Vybrat",
                                      style: Vzhled.textBtn,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      StreamBuilder(
                          stream: ref.collection("programmers").snapshots(),
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
                                      onTap: () {
                                        if (jenMenit) return;
                                        programmer = Programmer(
                                            data["name"], data["id"]);
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop("dialog");
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(data["name"]),
                                            Row(
                                              children: [
                                                if (!jenMenit)
                                                  TextButton(
                                                    onPressed: () {
                                                      programmer = Programmer(
                                                          data["name"],
                                                          data["id"]);
                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .pop("dialog");
                                                    },
                                                    child: const Text(
                                                      "Vybrat",
                                                      style: Vzhled.textBtn,
                                                    ),
                                                  ),
                                                IconButton(
                                                  onPressed: () {
                                                    editId = data["id"];

                                                    setState(() {
                                                      showAddProgrammer = true;
                                                      editing = true;
                                                      nameCon =
                                                          TextEditingController(
                                                              text:
                                                                  data["name"]);
                                                    });
                                                  },
                                                  icon: const Icon(Icons.edit,
                                                      color: Vzhled.textColor),
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    showReallyDelete(context,
                                                        () async {
                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .pop("dialog");
                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .pop("dialog");
                                                      if (doc != null) {
                                                        Navigator.of(context,
                                                                rootNavigator:
                                                                    true)
                                                            .pop("dialog");
                                                      }

                                                      // deleting all records
                                                      await ref
                                                          .collection("records")
                                                          .where("programmer",
                                                              isEqualTo:
                                                                  data["id"])
                                                          .get()
                                                          .then((value) {
                                                        for (var snap
                                                            in value.docs) {
                                                          ref
                                                              .collection(
                                                                  "records")
                                                              .doc(snap.id)
                                                              .delete();
                                                        }
                                                      });

                                                      // deleting
                                                      await ref
                                                          .collection(
                                                              "programmers")
                                                          .doc(data["id"])
                                                          .delete();
                                                    },
                                                        doNavigatorPop: false,
                                                        text:
                                                            "Odstranit programátora a všechny jeho záznamy?");
                                                  },
                                                  icon: const Icon(Icons.delete,
                                                      color: Vzhled.textColor),
                                                ),
                                              ],
                                            )
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
                            showAddProgrammer = true;
                          });
                        },
                        child: const Text(
                          "Přidat nového programátora",
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

  return programmer;
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
