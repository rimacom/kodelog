import 'package:fleather/fleather.dart';

extension ActualJson on ParchmentDocument {
  List<Map<String, dynamic>> toActualJson() {
    var out = <Map<String, dynamic>>[];
    var d = toDelta().toList();
    for (var element in d) {
      out.add(element.toJson());
    }
    return out;
  }
}
