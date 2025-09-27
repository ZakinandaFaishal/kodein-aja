import 'package:flutter/services.dart';
import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/asymmetric/api.dart';

class RSAHelper {
  static Future<Encrypter> getEncrypter() async {
    final publicPem = await rootBundle.loadString('assets/keys/public.pem');
    final privatePem = await rootBundle.loadString('assets/keys/private.pem');
    final parser = RSAKeyParser();
    final publicKey = parser.parse(publicPem);
    final privateKey = parser.parse(privatePem); // RSAPrivateKey

    // Cast ke RSAPublicKey & RSAPrivateKey
    if (publicKey is! RSAPublicKey || privateKey is! RSAPrivateKey) {
      throw Exception("Invalid RSA key format");
    }
    final RSAPublicKey rsaPublicKey = publicKey;
    final RSAPrivateKey rsaPrivateKey = privateKey;
    return Encrypter(RSA(publicKey: rsaPublicKey, privateKey: rsaPrivateKey));
  }
}
