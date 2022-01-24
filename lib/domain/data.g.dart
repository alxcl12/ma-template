// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BoardGame _$BoardGameFromJson(Map<String, dynamic> json) => BoardGame(
      id: json['id'] as int?,
      name: json['name'] as String,
      price: json['price'] as int,
      minAge: json['minAge'] as int,
      maxAge: json['maxAge'] as int,
      publisher: json['publisher'] as String,
    );

Map<String, dynamic> _$BoardGameToJson(BoardGame instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'minAge': instance.minAge,
      'maxAge': instance.maxAge,
      'publisher': instance.publisher,
    };

ResponseData _$ResponseDataFromJson(Map<String, dynamic> json) => ResponseData(
      code: json['code'] as int,
      meta: json['meta'],
      data: json['data'] as List<dynamic>,
    );

Map<String, dynamic> _$ResponseDataToJson(ResponseData instance) =>
    <String, dynamic>{
      'code': instance.code,
      'meta': instance.meta,
      'data': instance.data,
    };
