import 'package:xml/xml.dart';

class WeaponMountOption {
  final String sourceId;
  final String guid;
  final String name;
  final String category;
  final String slots;
  final String avail;
  final String cost;
  final bool includedInParent;

  WeaponMountOption({
    required this.sourceId,
    required this.guid,
    required this.name,
    required this.category,
    required this.slots,
    required this.avail,
    required this.cost,
    required this.includedInParent,
  });

  factory WeaponMountOption.fromXmlElement(XmlElement element) {
    return WeaponMountOption(
      sourceId: element.getElement('sourceid')?.innerText ?? '',
      guid: element.getElement('guid')?.innerText ?? '',
      name: element.getElement('name')?.innerText ?? '',
      category: element.getElement('category')?.innerText ?? '',
      slots: element.getElement('slots')?.innerText ?? '0',
      avail: element.getElement('avail')?.innerText ?? '',
      cost: element.getElement('cost')?.innerText ?? '',
      includedInParent: element.getElement('includedinparent')?.innerText == 'True',
    );
  }
}