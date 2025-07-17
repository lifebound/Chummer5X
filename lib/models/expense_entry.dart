import 'package:uuid/uuid.dart';
import 'package:xml/xml.dart';

// Expense tracking for XML modification
enum ExpenseType { karma, nuyen }

class ExpenseEntry {
  final String guid;
  final ExpenseType type;
  final num amount; // Changed from int to num to handle both int and double
  final String reason;
  final DateTime date;
  final bool refund;
  final bool forceCareerVisible;

  ExpenseEntry({
    String? guid,
    required this.type,
    required this.amount,
    required this.reason,
    DateTime? date,
    this.refund = false,
    this.forceCareerVisible = false,
  }) : date = date ?? DateTime.now(),
       guid = guid ?? _generateGuid();

  static String _generateGuid() {
    const uuid = Uuid();
    return uuid.v4();
  }

  XmlElement toXml() {
    final typeString = type == ExpenseType.karma ? 'Karma' : 'Nuyen';
    final dateString = date.toIso8601String(); // Full ISO format: 2025-04-19T00:00:00
    XmlElement xmlElement = XmlElement(
      XmlName('expense'),
      [],
      [
        XmlElement(XmlName('guid'), [], [XmlText(guid)]),
        XmlElement(XmlName('date'), [], [XmlText(dateString)]),
        XmlElement(XmlName('amount'), [], [XmlText(amount.toString())]),
        XmlElement(XmlName('reason'), [], [XmlText(reason)]),
        XmlElement(XmlName('type'), [], [XmlText(typeString)]),
        XmlElement(XmlName('refund'), [], [XmlText(refund ? 'True' : 'False')]),
        XmlElement(XmlName('forcecareervisible'), [], [XmlText(forceCareerVisible ? 'True' : 'False')]),
        XmlElement(
          XmlName('undo'),
          [],
          [
            XmlElement(XmlName('karmatype'), [], [XmlText('ManualAdd')]),
            XmlElement(XmlName('nuyentype'), [], [XmlText('AddCyberware')]),
            XmlElement(XmlName('objectid')),
            XmlElement(XmlName('qty'), [], [XmlText('0')]),
            XmlElement(XmlName('extra')),
          ],
        ),
      ],
    );

    return xmlElement;

  }

  factory ExpenseEntry.fromXml(XmlElement xmlString) {
    // Parse all the XML fields
    final guid = _getElementText(xmlString, 'guid') ?? _generateGuid();
    final typeString = _getElementText(xmlString, 'type');
    final amountString = _getElementText(xmlString, 'amount') ?? '0';
    final reason = _getElementText(xmlString, 'reason') ?? '';
    final dateString = _getElementText(xmlString, 'date');
    final refund = _getElementText(xmlString, 'refund')?.toLowerCase() == 'true';
    final forceCareerVisible = _getElementText(xmlString, 'forcecareervisible')?.toLowerCase() == 'true';

    // Parse amount as num to handle both int and double values
    num amount = 0;
    if (amountString.isNotEmpty) {
      // Try parsing as double first (handles both int and double)
      final doubleValue = double.tryParse(amountString);
      if (doubleValue != null) {
        // If it's a whole number, keep it as int, otherwise as double
        amount = doubleValue == doubleValue.toInt() ? doubleValue.toInt() : doubleValue;
      }
    }

    DateTime? parsedDate;
    if (dateString != null) {
      parsedDate = DateTime.tryParse(dateString);
    }

    return ExpenseEntry(
      guid: guid.isNotEmpty ? guid : null, // Let it generate a new GUID if empty
      type: typeString?.toLowerCase() == 'karma' ? ExpenseType.karma : ExpenseType.nuyen,
      amount: amount,
      reason: reason,
      date: parsedDate,
      refund: refund,
      forceCareerVisible: forceCareerVisible,
    );
  }

  static String? _getElementText(XmlElement parent, String elementName) {
    final element = parent.findElements(elementName).firstOrNull;
    return element?.innerText;
  }

  @override
  String toString() => 'ExpenseEntry(guid: $guid, type: $type, amount: $amount, reason: $reason, date: $date, refund: $refund, forceCareerVisible: $forceCareerVisible)';
}