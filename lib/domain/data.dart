import 'package:json_annotation/json_annotation.dart';
part 'data.g.dart';

@JsonSerializable()
class BoardGame {
  int? id;
  String name;
  int price;
  int minAge;
  int maxAge;
  String publisher;

  BoardGame(
      {required this.id,
      required this.name,
      required this.price,
      required this.minAge,
      required this.maxAge,
      required this.publisher});

  factory BoardGame.fromJson(Map<String, dynamic> json) => _$BoardGameFromJson(json);
  Map<String, dynamic> toJson() => _$BoardGameToJson(this);
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
