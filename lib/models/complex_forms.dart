import 'package:chummer5x/utils/xml_element_extensions.dart';
import 'package:xml/xml.dart';

class ComplexForm {
  final String name;
  final String target;
  final String duration;
  final String fading;
  final String source;
  final String page;
  final String description;

  const ComplexForm({
    required this.name,
    this.target = '',
    this.duration = '',
    this.fading = '',
    this.source = '',
    this.description = '',
    this.page = '',
  });

  factory ComplexForm.fromJson(Map<String, dynamic> json) => ComplexForm(
    name: json['name'] ?? '',
    target: json['target'] ?? '',
    duration: json['duration'] ?? '',
    fading: json['fading'] ?? '',
    source: json['source'] ?? '',
    description: json['description'] ?? '',
    page: json['page'] ?? '',
  );
  factory ComplexForm.fromXml(XmlElement xml) => ComplexForm(
    name: xml.getElementText('name') ?? '',
    target: xml.getElementText('target') ?? '',
    duration: xml.getElementText('duration') ?? '',
    fading: xml.getElementText('fv') ?? '',
    source: xml.getElementText('source') ?? '',
    description: xml.getElementText('description') ?? '',
    page: xml.getElementText('page') ?? '',
  );
  // Utility getters
  String get displayName => name;
  bool get hasCompleteInfo => 
    name.isNotEmpty && 
    target.isNotEmpty && 
    duration.isNotEmpty && 
    fading.isNotEmpty && 
    source.isNotEmpty;
}