class BoardGame {
  static const tableBoardGames = 'boardGames';
  static const colId = 'id';
  static const colName = 'name';
  static const colPrice = 'price';
  static const colMinAge = 'minAge';
  static const colMaxAge = 'maxAge';
  static const colPublisher = 'publisher';

  late int? id;
  late String name;
  late int price;
  late int minAge;
  late int maxAge;
  late String publisher;

  BoardGame(
      this.id, this.name, this.price, this.minAge, this.maxAge, this.publisher);

  BoardGame.withoutId(
      this.name, this.price, this.minAge, this.maxAge, this.publisher) {
    id = null;
  }

  BoardGame.fromMap(Map<String, dynamic> map) {
    id = map[colId];
    name = map[colName];
    price = map[colPrice];
    minAge = map[colMinAge];
    maxAge = map[colMaxAge];
    publisher = map[colPublisher];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'name': this.name,
      'price': this.price,
      'minAge': this.minAge,
      'maxAge': this.maxAge,
      'publisher': this.publisher
    };

    if (id != null) {
      map[colId] = id;
    }
    return map;
  }

  factory BoardGame.fromJson(Map<String, dynamic> json) {
    return BoardGame(json['id'], json['name'], json['price'], json['minAge'],
        json['maxAge'], json['publisher']);
  }
}
