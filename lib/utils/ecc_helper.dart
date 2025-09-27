// utils/ecc_helper.dart (Perbaikan Final)

import 'dart:convert';
import 'package:pointycastle/export.dart';
import 'package:pointycastle/pointycastle.dart';
import 'dart:typed_data';
import 'dart:math';
import 'package:convert/convert.dart';

class ECCHelper {
  late ECPrivateKey privateKey;
  late ECPublicKey publicKey;

  Future<void> init() async {
    final keyPair = _generateKeyPair();
    publicKey = keyPair.publicKey as ECPublicKey;
    privateKey = keyPair.privateKey as ECPrivateKey;
  }

  SecureRandom _getSecureRandom() {
    final secureRandom = FortunaRandom();
    final seedSource = Random.secure();
    final seeds = <int>[];
    for (var i = 0; i < 32; i++) {
      seeds.add(seedSource.nextInt(256));
    }
    secureRandom.seed(KeyParameter(Uint8List.fromList(seeds)));
    return secureRandom;
  }

  AsymmetricKeyPair<PublicKey, PrivateKey> _generateKeyPair() {
    final secureRandom = _getSecureRandom();
    final keyParams = ECKeyGeneratorParameters(ECCurve_secp256r1());
    final generator = ECKeyGenerator();
    generator.init(ParametersWithRandom(keyParams, secureRandom));
    return generator.generateKeyPair();
  }

  String sign(String plainText) {
    final secureRandom = _getSecureRandom(); // <-- Ambil instance SecureRandom

    final signer = ECDSASigner(SHA256Digest(), null);

    // Inisialisasi signer dengan parameter kunci privat DAN secureRandom
    final params = ParametersWithRandom(
      PrivateKeyParameter(privateKey),
      secureRandom,
    ); // <-- Gabungkan
    signer.init(true, params); // <-- Berikan parameter yang sudah digabung

    final messageBytes = Uint8List.fromList(utf8.encode(plainText));
    final signature = signer.generateSignature(messageBytes) as ECSignature;

    final rHex = signature.r.toRadixString(16).padLeft(64, '0');
    final sHex = signature.s.toRadixString(16).padLeft(64, '0');

    return rHex + sHex;
  }

  bool verify(String plainText, String signatureHex) {
    try {
      if (signatureHex.length != 128) return false;

      final verifier = ECDSASigner(SHA256Digest(), null);
      verifier.init(false, PublicKeyParameter(publicKey));

      final messageBytes = Uint8List.fromList(utf8.encode(plainText));

      final r = BigInt.parse(signatureHex.substring(0, 64), radix: 16);
      final s = BigInt.parse(signatureHex.substring(64, 128), radix: 16);

      final ecSignature = ECSignature(r, s);
      return verifier.verifySignature(messageBytes, ecSignature);
    } catch (e) {
      print("Error verifying signature: $e");
      return false;
    }
  }
}
