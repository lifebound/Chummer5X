import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:xml/xml.dart';
import '../models/shadowrun_character.dart';
import 'enhanced_chumer_xml_service.dart';
import '../utils/platform_file_handler.dart';
import 'package:chummer5x/models/expense_entry.dart';

class MutableXmlService extends EnhancedChummerXmlService {
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
      final fileContent = await file.readAsBytes();
      final bytes = fileContent;
      if (bytes.isEmpty) {
        throw Exception('File is empty: $filePath');
      }
      final String xmlContent = utf8.decode(bytes);
        String cleanXmlContent = xmlContent;
        if (cleanXmlContent.startsWith('\uFEFF')) {
          cleanXmlContent = cleanXmlContent.substring(1);
          debugPrint('Explicit BOM \\uFEFF stripped after UTF-8 decode.');
        } else {
          debugPrint('No \\uFEFF BOM found at the beginning of content after UTF-8 decode.');
        }
      
      _cachedDocument = XmlDocument.parse(xmlContent);
      _originalFilePath = filePath;
      _pendingExpenses.clear();

      // Parse character normally
      return EnhancedChummerXmlService.parseCharacterXml(xmlContent);
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

      return EnhancedChummerXmlService.parseCharacterXml(xmlContent);
    } catch (e) {
      debugPrint('Error parsing and caching XML content: $e');
      _cachedDocument = null;
      return null;
    }
  }

  /// Add an expense entry to the cached XML document
  void addExpenseEntry({
    required ExpenseType type,
    required num amount,
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

    debugPrint(expensesElement == null ? 'No expenses element found, creating new one.' : 'Expenses element found with ${expensesElement.children.length} entries, adding new ones.');

    if (expensesElement == null) {
      // Create expenses element if it doesn't exist
      expensesElement = XmlElement(XmlName('expenses'));
      characterElement.children.add(expensesElement);
    }

    // Add all pending expenses
    for (final expense in _pendingExpenses) {
      final expenseXmlElement = expense.toXml();
      expensesElement.children.add(expenseXmlElement);
    }

    // Clear pending expenses after export
    _pendingExpenses.clear();


    final expenseCount = clonedDoc.findAllElements('expense').length;
    debugPrint('Exporting modified XML with ${expensesElement.children.length} expense entries. cloned doc has a number of expense entries: $expenseCount');

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
  Future<String?> exportModifiedXmlForSharing(String filename) async {
    final modifiedXml = exportModifiedXml();
    _cachedDocument = XmlDocument.parse(modifiedXml); // Ensure cached document is updated
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
