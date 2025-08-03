import 'package:xml/xml.dart';

extension XmlElementExtensions on XmlElement {
  List<T> parseList<T>({
    required String collectionTagName,
    required String itemTagName,
    required T Function(XmlElement element) fromXml,
  }) {
    final collectionElement = findElements(collectionTagName).firstOrNull;
    if (collectionElement == null) {
      return [];
    }
    return collectionElement.findElements(itemTagName).map(fromXml).toList();
  }
}
