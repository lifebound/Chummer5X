import 'package:xml/xml.dart';

extension XmlElementExtensions on XmlElement {
  List<T> parseList<T>({
    required String collectionTagName,
    required String itemTagName,
    required T Function(XmlElement element) fromXml,
  }) {
    // If collectionTagName is empty, parse items directly from this element
    if (collectionTagName.isEmpty) {
      return findElements(itemTagName).map(fromXml).toList();
    }
    
    final collectionElement = findElements(collectionTagName).firstOrNull;
    if (collectionElement == null) {
      return [];
    }
    return collectionElement.findElements(itemTagName).map(fromXml).toList();
  }
  
  String? getElementText(String tagName) {
    return findElements(tagName).firstOrNull?.innerText;
  }
  
  String getString(String tagName, {String defaultValue = ''}) {
    return getElementText(tagName) ?? defaultValue;
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
