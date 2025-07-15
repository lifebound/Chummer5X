import 'package:uuid/uuid.dart';

// Expense tracking for XML modification
enum ExpenseType { karma, nuyen }

class ExpenseEntry {
  final String guid;
  final ExpenseType type;
  final int amount;
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

  String toXml() {
    final typeString = type == ExpenseType.karma ? 'Karma' : 'Nuyen';
    final dateString = date.toIso8601String(); // Full ISO format: 2025-04-19T00:00:00
    
    return '''    <expense>
      <guid>$guid</guid>
      <date>$dateString</date>
      <amount>$amount</amount>
      <reason>$reason</reason>
      <type>$typeString</type>
      <refund>${refund ? 'True' : 'False'}</refund>
      <forcecareervisible>${forceCareerVisible ? 'True' : 'False'}</forcecareervisible>
      <undo>
        <karmatype>ManualAdd</karmatype>
        <nuyentype>AddCyberware</nuyentype>
        <objectid />
        <qty>0</qty>
        <extra />
      </undo>
    </expense>''';
  }

  factory ExpenseEntry.fromXml(String xmlString) {
    // Parse all the XML fields
    final guidMatch = RegExp(r'<guid>(.*?)</guid>').firstMatch(xmlString);
    final typeMatch = RegExp(r'<type>(.*?)</type>').firstMatch(xmlString);
    final amountMatch = RegExp(r'<amount>(.*?)</amount>').firstMatch(xmlString);
    final reasonMatch = RegExp(r'<reason>(.*?)</reason>').firstMatch(xmlString);
    final dateMatch = RegExp(r'<date>(.*?)</date>').firstMatch(xmlString);
    final refundMatch = RegExp(r'<refund>(.*?)</refund>').firstMatch(xmlString);
    final forceCareerVisibleMatch = RegExp(r'<forcecareervisible>(.*?)</forcecareervisible>').firstMatch(xmlString);

    final guid = guidMatch?.group(1) ?? '';
    final typeString = typeMatch?.group(1) ?? '';
    final type = typeString.toLowerCase() == 'karma' ? ExpenseType.karma : ExpenseType.nuyen;
    final amount = int.tryParse(amountMatch?.group(1) ?? '0') ?? 0;
    final reason = reasonMatch?.group(1) ?? '';
    final dateString = dateMatch?.group(1);
    final refund = refundMatch?.group(1)?.toLowerCase() == 'true';
    final forceCareerVisible = forceCareerVisibleMatch?.group(1)?.toLowerCase() == 'true';
    
    DateTime? parsedDate;
    if (dateString != null) {
      parsedDate = DateTime.tryParse(dateString);
    }

    return ExpenseEntry(
      guid: guid.isNotEmpty ? guid : null, // Let it generate a new GUID if empty
      type: type,
      amount: amount,
      reason: reason,
      date: parsedDate,
      refund: refund,
      forceCareerVisible: forceCareerVisible,
    );
  }

  @override
  String toString() => 'ExpenseEntry(guid: $guid, type: $type, amount: $amount, reason: $reason, date: $date, refund: $refund, forceCareerVisible: $forceCareerVisible)';
}