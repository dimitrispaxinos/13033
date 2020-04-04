import 'package:json_annotation/json_annotation.dart';
part 'categoryStatistics.g.dart';

@JsonSerializable()
class CategoryStatistics {
  int categoryId;
  int numberOfMessages;

  CategoryStatistics(this.categoryId, this.numberOfMessages);

  factory CategoryStatistics.fromJson(Map<String, dynamic> json) =>
      _$CategoryStatisticsFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryStatisticsToJson(this);
}
