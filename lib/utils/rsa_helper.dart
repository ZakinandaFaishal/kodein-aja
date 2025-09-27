import 'package:flutter/services.dart';
import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/asymmetric/api.dart'; // RSAPublicKey/RSAPrivateKey

class RSAHelper {
  static Future<Encrypter> getEncrypter() async {
    // Load key dari assets
    final publicPemRaw = await rootBundle.loadString('assets/keys/public.pem');
    final privatePemRaw = await rootBundle.loadString(
      'assets/keys/private.pem',
    );

    // SOLUSI: Hapus semua karakter '\r' (Carriage Return)
    final publicPem = publicPemRaw.replaceAll('\r', '');
    final privatePem = privatePemRaw.replaceAll('\r', '');

    // Parsing RSA key
    final parser = RSAKeyParser();
    final parsedPublic = parser.parse(publicPem);
    final parsedPrivate = parser.parse(
      privatePem,
    ); // Gunakan variabel yang sudah bersih

    // Cast ke RSAPublicKey & RSAPrivateKey
    if (parsedPublic is! RSAPublicKey || parsedPrivate is! RSAPrivateKey) {
      throw Exception("Invalid RSA key format");
    }
    final RSAPublicKey publicKey = parsedPublic;
    final RSAPrivateKey privateKey = parsedPrivate;

    // Buat Encrypter
    return Encrypter(RSA(publicKey: publicKey, privateKey: privateKey));
  }
}
