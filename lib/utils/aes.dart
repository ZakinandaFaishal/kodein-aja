import 'package:encrypt/encrypt.dart';

class AESHelper {
  final Key key = Key.fromUtf8('12345678901234567890123456789012'); // 32 chars = 256 bits
  final IV iv = IV.fromLength(16); // IV tetap 16 byte
  late final Encrypter encrypter = Encrypter(AES(key));

  String encryptText(String plainText) => encrypter.encrypt(plainText, iv: iv).base64;
  String decryptText(String cipherText) => encrypter.decrypt64(cipherText, iv: iv);
}
