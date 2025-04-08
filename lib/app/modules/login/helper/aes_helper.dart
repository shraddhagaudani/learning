import 'dart:convert';
import 'package:encrypt/encrypt.dart';

class AESHelper {
  static final _keyBase64 = 'ZkFuc09ubHltT2JJbElPbnNtQXN0RXJrRXkyMjExMjQ=';
  static final _ivBase64 = 'TW9iaWxpb25zRmFuT25seQ==';

  static final _key = Key(base64Decode(_keyBase64));
  static final _iv = IV(base64Decode(_ivBase64));

  static final _encrypter = Encrypter(AES(_key, mode: AESMode.cbc));

  static String encryptText(String plainText) {
    final encrypted = _encrypter.encrypt(plainText, iv: _iv);
    return encrypted.base64;
  }

  static String decryptText(String encryptedText) {
    final decrypted = _encrypter.decrypt64(encryptedText, iv: _iv);
    print("Encryptext:$encryptedText");
    print("decrypted:$decrypted");
    return decrypted;
  }
}
