final months = [
  Month("Leden", 31, 0),
  Month("Únor", 28, 1),
  Month("Březen", 31, 2),
  Month("Duben", 30, 3),
  Month("Květen", 31, 4),
  Month("Červen", 30, 5),
  Month("Červenec", 31, 6),
  Month("Srpen", 31, 7),
  Month("Září", 30, 8),
  Month("Říjen", 31, 9),
  Month("Listopad", 30, 10),
  Month("Prosinec", 31, 11),
];

class Month {
  String name;
  int days;
  int position;

  Month(this.name, this.days, this.position);
}
