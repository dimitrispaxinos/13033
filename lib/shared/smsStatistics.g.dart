// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'smsStatistics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SmsStatistics _$SmsStatisticsFromJson(Map<String, dynamic> json) {
  return SmsStatistics(
    json['date'] as String,
    (json['allCategoryStatistics'] as List)
        ?.map((e) => e == null
            ? null
            : CategoryStatistics.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$SmsStatisticsToJson(SmsStatistics instance) =>
    <String, dynamic>{
      'date': instance.date,
      'allCategoryStatistics':
          instance.allCategoryStatistics?.map((e) => e?.toJson())?.toList(),
    };
