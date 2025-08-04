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
  String? getElementText(String tagName) {
    return findElements(tagName).firstOrNull?.innerText;
  }
  int getInt(String tagName, {int defaultValue = 0}) {
    final text = getElementText(tagName);
    return text != null ? int.tryParse(text) ?? defaultValue : defaultValue;
  }
  double getDouble(String tagName, {double defaultValue = 0.0}) {
    final text = getElementText(tagName);
    return text != null ? double.tryParse(text) ?? defaultValue : defaultValue;
  }
  bool getBool(String tagName, {bool defaultValue = false}) {
    final text = getElementText(tagName);
    if (text == null) return defaultValue;
    final lowerText = text.toLowerCase();
    if (lowerText == 'true' || lowerText == 'yes' || lowerText == '1') {
      return true;
    } else if (lowerText == 'false' || lowerText == 'no' || lowerText == '0') {
      return false;
    } else {
      return defaultValue;
    }
  }
}
