// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'categoryStatistics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryStatistics _$CategoryStatisticsFromJson(Map<String, dynamic> json) {
  return CategoryStatistics(
    json['categoryId'] as int,
    json['numberOfMessages'] as int,
  );
}

Map<String, dynamic> _$CategoryStatisticsToJson(CategoryStatistics instance) =>
    <String, dynamic>{
      'categoryId': instance.categoryId,
      'numberOfMessages': instance.numberOfMessages,
    };
