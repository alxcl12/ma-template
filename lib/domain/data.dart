import 'package:json_annotation/json_annotation.dart';
part 'data.g.dart';

class ReturnedFromPop {
  BoardGame entity;
  int type;
  bool local;

  ReturnedFromPop(this.entity, this.type, this.local);
}

@JsonSerializable()
class BoardGame {
  late int? id;
  late String name;
  late int price;
  late int minAge;
  late int maxAge;
  late String publisher;

  static const tableBoardGames = 'boardGames';
  static const colId = 'id';
  static const colName = 'name';
  static const colPrice = 'price';
  static const colMinAge = 'minAge';
  static const colMaxAge = 'maxAge';
  static const colPublisher = 'publisher';

  BoardGame(
      {required this.id,
      required this.name,
      required this.price,
      required this.minAge,
      required this.maxAge,
      required this.publisher});

  factory BoardGame.fromJson(Map<String, dynamic> json) =>
      _$BoardGameFromJson(json);

  Map<String, dynamic> toJson() => _$BoardGameToJson(this);

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
      'name': name,
      'price': price,
      'minAge': minAge,
      'maxAge': maxAge,
      'publisher': publisher
    };

    if (id != null) {
      map[colId] = id;
    }
    return map;
  }
}

@JsonSerializable()
class ResponseData {
  int code;
  dynamic meta;
  List<dynamic> data;
  ResponseData({required this.code, this.meta, required this.data});
  factory ResponseData.fromJson(Map<String, dynamic> json) =>
      _$ResponseDataFromJson(json);
  Map<String, dynamic> toJson() => _$ResponseDataToJson(this);
}
