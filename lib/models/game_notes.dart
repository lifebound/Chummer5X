/// RTF document state tracker
class _RtfState {
  bool bold = false;
  bool italic = false;
  bool underline = false;
  int fontSize = 12;
  int fontIndex = 0;
  
  _RtfState copy() {
    return _RtfState()
      ..bold = bold
      ..italic = italic
      ..underline = underline
      ..fontSize = fontSize
      ..fontIndex = fontIndex;
  }
}

/// Utility class for converting RTF content to Markdown using proper state machine
class RtfToMarkdownConverter {
  /// Convert RTF content to Markdown using stateful parsing
  static String convertRtfToMarkdown(String rtfContent) {
    if (rtfContent.isEmpty) return '';
    
    final parser = _RtfParser(rtfContent);
    return parser.parseToMarkdown();
  }
  
  /// Extract just the plain text from RTF using stateful parsing
  static String extractPlainText(String rtfContent) {
    if (rtfContent.isEmpty) return '';
    
    final parser = _RtfParser(rtfContent);
    return parser.parseToPlainText();
  }
}

/// Stateful RTF parser that tracks document state as it processes commands
class _RtfParser {
  final String _input;
  int _position = 0;
  final List<_RtfState> _stateStack = [_RtfState()];
  final StringBuffer _output = StringBuffer();
  final List<bool> _inFontTableStack = [false];
  final List<bool> _inColorTableStack = [false];
  final List<bool> _inGeneratorStack = [false];
  
  _RtfParser(this._input);
  
  _RtfState get _currentState => _stateStack.last;
  bool get _inFontTable => _inFontTableStack.last;
  bool get _inColorTable => _inColorTableStack.last;
  bool get _inGenerator => _inGeneratorStack.last;
  
  String parseToMarkdown() {
    _output.clear();
    _position = 0;
    _stateStack.clear();
    _stateStack.add(_RtfState());
    _inFontTableStack.clear();
    _inFontTableStack.add(false);
    _inColorTableStack.clear();
    _inColorTableStack.add(false);
    _inGeneratorStack.clear();
    _inGeneratorStack.add(false);
    
    while (_position < _input.length) {
      final char = _input[_position];
      
      if (char == '\\') {
        _handleControlSequence();
      } else if (char == '{') {
        _pushState();
      } else if (char == '}') {
        _popState();
      } else {
        // Only output text if we're not in a control structure
        if (!_inFontTable && !_inColorTable && !_inGenerator) {
          _output.write(char);
        }
        _position++;
      }
    }
    
    String result = _output.toString();
    
    // Clean up artifacts
    result = _cleanupArtifacts(result);
    
    // Post-process to convert bracketed headers to markdown
    result = result.replaceAllMapped(
      RegExp(r'^\[([^\]]+)\]', multiLine: true),
      (match) => '## ${match.group(1)}',
    );
    
    return result.trim();
  }
  
  String parseToPlainText() {
    _output.clear();
    _position = 0;
    _stateStack.clear();
    _stateStack.add(_RtfState());
    _inFontTableStack.clear();
    _inFontTableStack.add(false);
    _inColorTableStack.clear();
    _inColorTableStack.add(false);
    _inGeneratorStack.clear();
    _inGeneratorStack.add(false);
    
    while (_position < _input.length) {
      final char = _input[_position];
      
      if (char == '\\') {
        _handleControlSequenceForPlainText();
      } else if (char == '{') {
        _pushState();
      } else if (char == '}') {
        _popState();
      } else {
        // Only output text if we're not in a control structure
        if (!_inFontTable && !_inColorTable && !_inGenerator) {
          _output.write(char);
        }
        _position++;
      }
    }
    
    String result = _output.toString();
    result = _cleanupArtifacts(result);
    return result.trim();
  }
  
  String _cleanupArtifacts(String content) {
    // Remove common RTF artifacts
    content = content.replaceAll(RegExp(r'd-\d+'), ''); // Remove "d-240" style artifacts
    content = content.replaceAll(RegExp(r'^[^a-zA-Z0-9\[\n]*'), ''); // Remove junk at start
    content = content.replaceAll(RegExp(r'\n\s*\n\s*\n+'), '\n\n'); // Multiple newlines to double
    return content;
  }
  
  void _pushState() {
    _stateStack.add(_currentState.copy());
    _inFontTableStack.add(_inFontTableStack.last);
    _inColorTableStack.add(_inColorTableStack.last);
    _inGeneratorStack.add(_inGeneratorStack.last);
    _position++;
  }
  
  void _popState() {
    if (_stateStack.length > 1) {
      _stateStack.removeLast();
      _inFontTableStack.removeLast();
      _inColorTableStack.removeLast();
      _inGeneratorStack.removeLast();
    }
    _position++;
  }
  
  void _handleControlSequence() {
    _position++; // Skip the backslash
    
    if (_position >= _input.length) return;
    
    final char = _input[_position];
    
    // Handle control symbols (single character after backslash)
    if (!_isLetter(char)) {
      _handleControlSymbol(char);
      return;
    }
    
    // Handle control words (letters followed by optional number)
    final controlWord = _readControlWord();
    _handleControlWord(controlWord);
  }
  
  void _handleControlSequenceForPlainText() {
    _position++; // Skip the backslash
    
    if (_position >= _input.length) return;
    
    final char = _input[_position];
    
    // Handle control symbols
    if (!_isLetter(char)) {
      _handleControlSymbolForPlainText(char);
      return;
    }
    
    // Handle control words
    final controlWord = _readControlWord();
    _handleControlWordForPlainText(controlWord);
  }
  
  String _readControlWord() {
    final start = _position;
    
    // Read letters
    while (_position < _input.length && _isLetter(_input[_position])) {
      _position++;
    }
    
    final word = _input.substring(start, _position);
    
    // Read optional number
    if (_position < _input.length && (_isDigit(_input[_position]) || _input[_position] == '-')) {
      if (_input[_position] == '-') _position++; // Skip negative sign
      while (_position < _input.length && _isDigit(_input[_position])) {
        _position++;
      }
    }
    
    // Skip optional space delimiter
    if (_position < _input.length && _input[_position] == ' ') {
      _position++;
    }
    
    return word;
  }
  
  void _handleControlWord(String word) {
    switch (word) {
      case 'par':
        if (!_inFontTable && !_inColorTable && !_inGenerator) {
          _output.write('\n');
        }
        break;
      case 'tab':
        if (!_inFontTable && !_inColorTable && !_inGenerator) {
          _output.write('    '); // 4 spaces
        }
        break;
      case 'line':
        if (!_inFontTable && !_inColorTable && !_inGenerator) {
          _output.write('\n');
        }
        break;
      case 'fonttbl':
        _inFontTableStack[_inFontTableStack.length - 1] = true;
        break;
      case 'colortbl':
        _inColorTableStack[_inColorTableStack.length - 1] = true;
        break;
      case 'generator':
        _inGeneratorStack[_inGeneratorStack.length - 1] = true;
        break;
      case 'b':
        _currentState.bold = true;
        break;
      case 'i':
        _currentState.italic = true;
        break;
      case 'ul':
        _currentState.underline = true;
        break;
      // Skip common RTF structure words
      case 'rtf':
      case 'ansi':
      case 'ansicpg':
      case 'deff':
      case 'deflang':
      case 'deflangfe':
      case 'pard':
      case 'plain':
      case 'f':
      case 'fs':
      case 'lang':
      case 'uc':
      case 'sl':
      case 'slmult':
        // These are structural/formatting commands we ignore
        break;
      default:
        // Unknown control word - ignore
        break;
    }
  }
  
  void _handleControlWordForPlainText(String word) {
    switch (word) {
      case 'par':
      case 'line':
        if (!_inFontTable && !_inColorTable && !_inGenerator) {
          _output.write('\n');
        }
        break;
      case 'tab':
        if (!_inFontTable && !_inColorTable && !_inGenerator) {
          _output.write('    '); // 4 spaces
        }
        break;
      case 'fonttbl':
        _inFontTableStack[_inFontTableStack.length - 1] = true;
        break;
      case 'colortbl':
        _inColorTableStack[_inColorTableStack.length - 1] = true;
        break;
      case 'generator':
        _inGeneratorStack[_inGeneratorStack.length - 1] = true;
        break;
      // All other control words are ignored for plain text
    }
  }
  
  void _handleControlSymbol(String symbol) {
    switch (symbol) {
      case '\\':
        if (!_inFontTable && !_inColorTable && !_inGenerator) {
          _output.write('\\');
        }
        _position++;
        break;
      case '{':
        if (!_inFontTable && !_inColorTable && !_inGenerator) {
          _output.write('{');
        }
        _position++;
        break;
      case '}':
        if (!_inFontTable && !_inColorTable && !_inGenerator) {
          _output.write('}');
        }
        _position++;
        break;
      case '*':
        // This is a special case for {\*\generator ...} style control groups
        // Skip everything until the matching }
        _position++; // Skip the *
        break;
      default:
        _position++; // Skip unknown control symbol
        break;
    }
  }
  
  void _handleControlSymbolForPlainText(String symbol) {
    switch (symbol) {
      case '\\':
        if (!_inFontTable && !_inColorTable && !_inGenerator) {
          _output.write('\\');
        }
        _position++;
        break;
      case '{':
        if (!_inFontTable && !_inColorTable && !_inGenerator) {
          _output.write('{');
        }
        _position++;
        break;
      case '}':
        if (!_inFontTable && !_inColorTable && !_inGenerator) {
          _output.write('}');
        }
        _position++;
        break;
      case '*':
        // This is a special case for {\*\generator ...} style control groups
        _position++; // Skip the *
        break;
      default:
        _position++; // Skip unknown control symbol
        break;
    }
  }
  
  bool _isLetter(String char) {
    final code = char.codeUnitAt(0);
    return (code >= 65 && code <= 90) || (code >= 97 && code <= 122);
  }
  
  bool _isDigit(String char) {
    final code = char.codeUnitAt(0);
    return code >= 48 && code <= 57;
  }
}

class GameNotes {
  final String rawContent;
  final String? plainText;
  final String? markdownContent;

  const GameNotes({
    required this.rawContent,
    this.plainText,
    this.markdownContent,
  });

  factory GameNotes.fromRtf(String rtfContent) {
    final plainText = RtfToMarkdownConverter.extractPlainText(rtfContent);
    final markdownContent = RtfToMarkdownConverter.convertRtfToMarkdown(rtfContent);
    
    return GameNotes(
      rawContent: rtfContent,
      plainText: plainText.isNotEmpty ? plainText : null,
      markdownContent: markdownContent.isNotEmpty ? markdownContent : null,
    );
  }

  factory GameNotes.fromXml(String xmlContent) {
    // The XML content is the RTF content
    return GameNotes.fromRtf(xmlContent);
  }

  factory GameNotes.fromJson(Map<String, dynamic> json) {
    return GameNotes(
      rawContent: json['rawContent'] ?? '',
      plainText: json['plainText'],
      markdownContent: json['markdownContent'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rawContent': rawContent,
      'plainText': plainText,
      'markdownContent': markdownContent,
    };
  }

  String toXml() {
    return '<gamenotes>$rawContent</gamenotes>';
  }

  /// Get the best available content for display (prefers Markdown, falls back to plain text)
  String get displayContent => markdownContent ?? plainText ?? rawContent;

  /// Check if there's any meaningful content
  bool get hasContent {
    // Check if we have plain text content that's not empty
    if (plainText?.trim().isNotEmpty == true) {
      return true;
    }
    
    // Fall back to checking if raw content has meaningful text
    // Remove all RTF structures and see if anything is left
    String cleaned = rawContent;
    cleaned = cleaned.replaceAll(RegExp(r'\{[^{}]*\}'), ''); // Remove RTF structures
    cleaned = cleaned.replaceAll(RegExp(r'\\[a-zA-Z]+\d*'), ''); // Remove control words
    cleaned = cleaned.replaceAll(RegExp(r'\\[^a-zA-Z\s]'), ''); // Remove control symbols
    cleaned = cleaned.replaceAll(RegExp(r'[{}\\]'), ''); // Remove remaining RTF chars
    cleaned = cleaned.trim();
    
    return cleaned.isNotEmpty;
  }

  /// Get content formatted for specific display type
  String getContentForDisplay({bool preferMarkdown = true}) {
    if (preferMarkdown && markdownContent?.isNotEmpty == true) {
      return markdownContent!;
    }
    return plainText ?? rawContent;
  }

  /// Extract log entries (markdown headers and their content)
  List<String> get logEntries {
    final content = displayContent;
    final lines = content.split('\n');
    final entries = <String>[];
    
    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      // Look for markdown headers (converted from RTF brackets)
      if (line.startsWith('## ')) {
        // This is a log header, collect it and following lines until next header
        final entry = <String>[line];
        for (int j = i + 1; j < lines.length; j++) {
          final nextLine = lines[j].trim();
          if (nextLine.startsWith('## ')) {
            break; // Found next entry
          }
          if (nextLine.isNotEmpty) {
            entry.add(nextLine);
          }
        }
        entries.add(entry.join('\n'));
      }
    }
    
    return entries;
  }

  GameNotes copyWith({
    String? rawContent,
    String? plainText,
    String? markdownContent,
  }) {
    return GameNotes(
      rawContent: rawContent ?? this.rawContent,
      plainText: plainText ?? this.plainText,
      markdownContent: markdownContent ?? this.markdownContent,
    );
  }
}
