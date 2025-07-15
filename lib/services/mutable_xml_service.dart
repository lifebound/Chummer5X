import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:xml/xml.dart';
import '../models/shadowrun_character.dart';
import 'enhanced_chumer_xml_service.dart';
import '../utils/platform_file_handler.dart';
import 'package:chummer5x/models/expense_entry.dart';

class MutableXmlService extends EnhancedChumerXmlService {
  XmlDocument? _cachedDocument;
  String? _originalFilePath;
  final List<ExpenseEntry> _pendingExpenses = [];

  bool get hasLoadedDocument => _cachedDocument != null;
  String? get originalFilePath => _originalFilePath;
  List<ExpenseEntry> get pendingExpenses => List.unmodifiable(_pendingExpenses);

  /// Parse a character file and cache the XML document for modification
  Future<ShadowrunCharacter?> parseAndCacheCharacterFile(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        throw Exception('File not found: $filePath');
      }

      final xmlContent = await file.readAsString();
      _cachedDocument = XmlDocument.parse(xmlContent);
      _originalFilePath = filePath;
      _pendingExpenses.clear();

      // Parse character normally
      return EnhancedChumerXmlService.parseCharacterXml(xmlContent);
    } catch (e) {
      debugPrint('Error parsing and caching character file: $e');
      _cachedDocument = null;
      _originalFilePath = null;
      return null;
    }
  }

  /// Parse XML content and cache the document
  ShadowrunCharacter? parseAndCacheCharacterXml(String xmlContent) {
    try {
      _cachedDocument = XmlDocument.parse(xmlContent);
      _originalFilePath = null; // No file path for direct XML content
      _pendingExpenses.clear();

      return EnhancedChumerXmlService.parseCharacterXml(xmlContent);
    } catch (e) {
      debugPrint('Error parsing and caching XML content: $e');
      _cachedDocument = null;
      return null;
    }
  }

  /// Add an expense entry to the cached XML document
  void addExpenseEntry({
    required ExpenseType type,
    required int amount,
    required String reason,
    DateTime? date,
  }) {
    if (_cachedDocument == null) {
      throw StateError('No XML document loaded. Call parseAndCacheCharacterXml first.');
    }

    final expense = ExpenseEntry(
      type: type,
      amount: amount,
      reason: reason,
      date: date,
    );

    _pendingExpenses.add(expense);
  }

  /// Export the modified XML with all pending expenses added
  String exportModifiedXml() {
    if (_cachedDocument == null) {
      throw StateError('No XML document loaded. Call parseAndCacheCharacterXml first.');
    }

    // Clone the document to avoid modifying the original
    final clonedDoc = XmlDocument.parse(_cachedDocument!.toXmlString());
    
    // Find or create the expenses element
    final characterElement = clonedDoc.findElements('character').first;
    XmlElement? expensesElement = characterElement.findElements('expenses').firstOrNull;
    
    if (expensesElement == null) {
      // Create expenses element if it doesn't exist
      expensesElement = XmlElement(XmlName('expenses'));
      characterElement.children.add(expensesElement);
    }

    // Add all pending expenses
    for (final expense in _pendingExpenses) {
      final expenseXml = expense.toXml();
      final expenseDoc = XmlDocument.parse('<root>$expenseXml</root>');
      final expenseElement = expenseDoc.findElements('root').first.findElements('expense').first;
      expensesElement.children.add(expenseElement.copy());
    }

    // Clear pending expenses after export
    _pendingExpenses.clear();

    return clonedDoc.toXmlString(pretty: true);
  }

  /// Save the modified XML back to the original file (if available and platform supports it)
  Future<bool> saveToOriginalFile() async {
    if (_originalFilePath == null) {
      throw StateError('No original file path available. File was loaded from XML content.');
    }

    try {
      final modifiedXml = exportModifiedXml();
      final file = File(_originalFilePath!);
      await file.writeAsString(modifiedXml);
      return true;
    } catch (e) {
      debugPrint('Error saving to original file: $e');
      return false;
    }
  }

  /// Export modified XML using platform-appropriate method
  Future<String> exportModifiedXmlForSharing(String filename) async {
    final modifiedXml = exportModifiedXml();
    final fileHandler = PlatformFileHandler.create();
    return await fileHandler.exportXmlForSharing(modifiedXml, filename);
  }

  /// Check if the current platform supports direct file saving
  Future<bool> canSaveToOriginalFile() async {
    if (_originalFilePath == null) return false;
    
    final fileHandler = PlatformFileHandler.create();
    return await fileHandler.canWriteToFile(_originalFilePath!);
  }

  /// Clear all cached data
  void clearCache() {
    _cachedDocument = null;
    _originalFilePath = null;
    _pendingExpenses.clear();
  }
}
