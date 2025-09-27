class Caesar {
  static String encrypt(String text, int shift) {
    return String.fromCharCodes(text.codeUnits.map((c) {
      if (c >= 65 && c <= 90) {
        return ((c - 65 + shift) % 26) + 65;
      } else if (c >= 97 && c <= 122) {
        return ((c - 97 + shift) % 26) + 97;
      } else {
        return c;
      }
    }));
  }

  static String decrypt(String text, int shift) => encrypt(text, 26 - shift);
}
