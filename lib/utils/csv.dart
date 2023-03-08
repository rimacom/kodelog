import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:denikprogramatora/utils/datum_cas.dart';
import 'package:denikprogramatora/utils/loading_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

final csvHeader = "id,date,time_spent,language,rating,description".split(",");

Future<int> importCsv(String name) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
      dialogTitle: "Vyberte CSV soubor s databází",
      type: FileType.custom,
      allowedExtensions: ['csv']);
  if (result == null) return -1;
  var content = const CsvToListConverter(eol: "\n").convert(
      String.fromCharCodes(
          result.files.first.bytes!)); // načíst a rozdělit na řádky

  // Zkontrolovat počet sloupců
  if (content.first.length != csvHeader.length) {
    throw "CSV soubor není v platném formátu: neplatný počet sloupců";
  }

  Map<String, List<dynamic>> csv = {};
  var nazvySloupcu = [];
  for (var radek in content) {
    if (nazvySloupcu.isEmpty) {
      // získat názvy sloupců
      nazvySloupcu = radek;
      if (nazvySloupcu.any((element) => !csvHeader.contains(element))) {
        throw "CSV soubor není v platném formátu: neznámý název sloupce";
      }
      for (var nazevSloupce in nazvySloupcu) {
        csv[nazevSloupce] = [];
      }
      continue;
    }
    if (radek.length != nazvySloupcu.length) continue;

    // zkontrolovat, že máme všechny potřebné údaje v řádku
    var j = 0;
    var neplatny = false;
    for (var sloupec in radek) {
      if ((nazvySloupcu[j] != "description") && sloupec == "") {
        neplatny = true;
        break;
      }
      j++;
    }
    if (neplatny) continue;

    // přiřadit hodnotu sloupce do mapy
    var i = 0;
    for (var sloupec in radek) {
      csv[nazvySloupcu[i]]!.add(sloupec);
      i++;
    }
  }

  var userDoc = await FirebaseFirestore.instance
      .collection("users/${FirebaseAuth.instance.currentUser!.uid}/records")
      .get();
  var p = 0;
  var pouzitaId = <String>[];
  for (var i = 0; i < csv[nazvySloupcu[0]]!.length; i++) {
    var id = csv[nazvySloupcu[nazvySloupcu.indexOf("id")]]![i];
    if (pouzitaId.contains(id)) continue;
    pouzitaId.add(id);
    if (userDoc.docs.any((element) => element.id == id)) {
      continue;
    } // přeskočit dokumenty se stejným ID

    var date = csv[nazvySloupcu[nazvySloupcu.indexOf("date")]]![i].split("-");

    var timeToSec = textToSec(
        csv[nazvySloupcu[nazvySloupcu.indexOf("time_spent")]]![i] as String);
    if (timeToSec == null) continue;
    var timeSpent = Duration(seconds: timeToSec);

    var lang = csv[nazvySloupcu[nazvySloupcu.indexOf("language")]]![i];
    Map<String, dynamic> jazyk = {};
    if (jazyky.any((element) => element["jazyk"] == lang)) {
      jazyk = jazyky.where((element) => element["jazyk"] == lang).toList()[0];
    } else {
      jazyk = {"jazyk": lang, "barva": 0xffffffff};
    }

    var rating = csv[nazvySloupcu[nazvySloupcu.indexOf("rating")]]![i];
    if (rating > 5 || rating < 0) rating = 0;

    var desc = csv[nazvySloupcu[nazvySloupcu.indexOf("description")]]![i];
    DateTime? d;
    try {
      d = DateTime.parse(
          "${date[2]}-${int.parse(date[1]) < 10 ? '0${date[1]}' : date[1]}-${int.parse(date[0]) < 10 ? "0${date[0]}" : date[0]}");
    } catch (e) {
      continue;
    }

    await FirebaseFirestore.instance
        .collection("users/${FirebaseAuth.instance.currentUser!.uid}/records")
        .doc(id)
        .set({
      "date": d,
      "time_spent": timeSpent.durationText,
      "time_spentRaw": timeSpent.inSeconds,
      "programming_language": jazyk,
      "rating": rating,
      "descriptionRaw": desc,
      "description": null,
      "programmer": FirebaseAuth.instance.currentUser!.uid,
      "categories": []
    });
    p++;
  }
  return p;
}

Future<List<int>> exportCsv() async {
  List<List<dynamic>> csv = [csvHeader];
  var records = await FirebaseFirestore.instance
      .collection("users/${FirebaseAuth.instance.currentUser!.uid}/records")
      .get();
  for (var rec in records.docs) {
    var data = rec.data();
    csv.add([
      rec.id,
      (data['date'] as Timestamp).toDate().rawDateString,
      Duration(seconds: data['time_spentRaw']).durationText,
      data['programming_language']['jazyk'],
      data['rating'],
      data['descriptionRaw']
    ]);
  }
  return utf8.encode(const ListToCsvConverter(eol: "\n").convert(csv));
}

/// Převede `40 hodin 50 minut` na sekundy
int? textToSec(String vstup) {
  var match =
      RegExp(r'(\d+) hodin(?: |y |a )(\d+) minut(?:$|a$|y$)').firstMatch(vstup);
  if (match == null) return null;
  print(match.group(1));
  print(match.group(2));
  var h = int.tryParse(match.group(1)!);
  var m = int.tryParse(match.group(2)!);
  if (h == null || m == null) return null;
  return h * 3600 + m * 60;
}
