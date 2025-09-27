class Vigenere {
  static String encrypt(String text, String key) {
    key = key.toLowerCase();
    int keyIndex = 0;
    return String.fromCharCodes(text.codeUnits.map((c) {
      int shift = key.codeUnitAt(keyIndex % key.length) - 97;
      if (c >= 65 && c <= 90) { keyIndex++; return ((c - 65 + shift) % 26) + 65; }
      if (c >= 97 && c <= 122) { keyIndex++; return ((c - 97 + shift) % 26) + 97; }
      return c;
    }));
  }

  static String decrypt(String text, String key) {
    key = key.toLowerCase();
    int keyIndex = 0;
    return String.fromCharCodes(text.codeUnits.map((c) {
      int shift = key.codeUnitAt(keyIndex % key.length) - 97;
      if (c >= 65 && c <= 90) { keyIndex++; return ((c - 65 - shift + 26) % 26) + 65; }
      if (c >= 97 && c <= 122) { keyIndex++; return ((c - 97 - shift + 26) % 26) + 97; }
      return c;
    }));
  }
}
