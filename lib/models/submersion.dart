import 'package:chummer5x/models/initiation.dart';
import 'package:chummer5x/models/metamagic.dart';

class SubmersionGrade extends InitiationGrade {
  SubmersionGrade({
    required super.grade,
    required super.metamagics,
    required super.ordeal,
    required super.group,
    required super.schooling
  });

  factory SubmersionGrade.fromJson(Map<String, dynamic> json) {
    return SubmersionGrade(
      grade: int.tryParse(json['grade']?.toString() ?? '0') ?? 0,
      metamagics: (json['metamagics'] as List).map((item) => Metamagic.fromJson(item)).toList(),
      ordeal: json['ordeal'] == true,
      group: json['group'] == true,
      schooling: false
    );
  }
}