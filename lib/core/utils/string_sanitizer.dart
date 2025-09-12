/// Utilities to guard against malformed UTF-16 strings that can crash Text widgets
class StringSanitizer {
  /// Replaces invalid surrogate pairs with the replacement character �
  static String sanitizeUtf16(String input) {
    final StringBuffer buffer = StringBuffer();
    for (int i = 0; i < input.runes.length; i++) {
      // Using runes ensures we iterate over valid Unicode scalar values
      final int codePoint = input.runes.elementAt(i);
      buffer.writeCharCode(codePoint);
    }
    return buffer.toString();
  }
}


