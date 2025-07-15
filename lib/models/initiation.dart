import 'package:chummer5x/models/metamagic.dart';

class InitiationGrade {
  final int grade;
  List<Metamagic> metamagics;
  final bool ordeal;
  final bool group;
  final bool schooling;

  InitiationGrade({
    required this.grade,
    required this.metamagics,
    required this.ordeal,
    required this.group,
    required this.schooling,
  });

  factory InitiationGrade.fromJson(Map<String, dynamic> json) {
    return InitiationGrade(
      grade: int.tryParse(json['grade']?.toString() ?? '0') ?? 0,
      metamagics: (json['metamagics'] as List).map((item) => Metamagic.fromJson(item)).toList(),
      ordeal: json['ordeal'] == true,
      group: json['group'] == true,
      schooling: json['schooling'] == true
    );
  }
}