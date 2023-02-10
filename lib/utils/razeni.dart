import 'package:cloud_firestore/cloud_firestore.dart';

var razeni = [
  // VZESTUPNĚ ČAS
  (QueryDocumentSnapshot<Map<String, dynamic>> a,
          QueryDocumentSnapshot<Map<String, dynamic>> b) =>
      ((a.data()["fromDate"] as Timestamp).toDate().hour ==
              (b.data()["fromDate"] as Timestamp).toDate().hour)
          ? (a.data()["fromDate"] as Timestamp)
              .toDate()
              .minute
              .compareTo((b.data()["fromDate"] as Timestamp).toDate().minute)
          : (a.data()["fromDate"] as Timestamp)
              .toDate()
              .hour
              .compareTo((b.data()["fromDate"] as Timestamp).toDate().hour),
  // SESTUPNĚ ČAS
  (QueryDocumentSnapshot<Map<String, dynamic>> a,
          QueryDocumentSnapshot<Map<String, dynamic>> b) =>
      ((b.data()["fromDate"] as Timestamp).toDate().hour ==
              (a.data()["fromDate"] as Timestamp).toDate().hour)
          ? (b.data()["fromDate"] as Timestamp)
              .toDate()
              .minute
              .compareTo((a.data()["fromDate"] as Timestamp).toDate().minute)
          : (b.data()["fromDate"] as Timestamp)
              .toDate()
              .hour
              .compareTo((a.data()["fromDate"] as Timestamp).toDate().hour),
  // VZESTUPNĚ HODNOCENÍ
  (QueryDocumentSnapshot<Map<String, dynamic>> a,
          QueryDocumentSnapshot<Map<String, dynamic>> b) =>
      (a.data()["review"] as int).compareTo(b.data()["review"]),
  // SESTUPNĚ HODNOCENÍ
  (QueryDocumentSnapshot<Map<String, dynamic>> a,
          QueryDocumentSnapshot<Map<String, dynamic>> b) =>
      (b.data()["review"] as int).compareTo(a.data()["review"]),
];
