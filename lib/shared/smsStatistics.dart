import 'package:json_annotation/json_annotation.dart';
import 'package:metakinisi/shared/categoryStatistics.dart';

part 'smsStatistics.g.dart';

@JsonSerializable(explicitToJson: true)
class SmsStatistics {
  String date;
  List<CategoryStatistics> allCategoryStatistics;

  SmsStatistics(this.date,this.allCategoryStatistics);

  void addStatistics() {
    allCategoryStatistics.add(new CategoryStatistics(1, 0));
    allCategoryStatistics.add(new CategoryStatistics(2, 0));
    allCategoryStatistics.add(new CategoryStatistics(3, 0));
    allCategoryStatistics.add(new CategoryStatistics(4, 0));
    allCategoryStatistics.add(new CategoryStatistics(5, 0));
    allCategoryStatistics.add(new CategoryStatistics(6, 0));
  }

  int getTotalSmsOfTheDay() {
    var sum = 0;
    allCategoryStatistics.forEach((f) => {sum = sum + f.numberOfMessages});
    return sum;
  }

  factory SmsStatistics.fromJson(Map<String, dynamic> json) => _$SmsStatisticsFromJson(json);
  Map<String, dynamic> toJson() => _$SmsStatisticsToJson(this);

  // SmsStatistics.fromJson(String jsonStr) {
  //   final _map = jsonDecode(jsonStr);
  //   this.date = _map['date'];
  //   final _allCategoryStatistics = _map['allCategoryStatistics'];

  //   for (var i = 0; i < 6; i++) {
  //     this
  //         .allCategoryStatistics
  //         .add(new CategoryStatistics.fromJson(_allCategoryStatistics[i]));
  //   }
  // }
}
