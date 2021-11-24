import 'package:encrypt/encrypt.dart';

/// This is used for QR Code, the user id is encrypted
class AppAlgo {
  static final _key =
      Key.fromUtf8('som32charactershereeeeeeeeeeeee!'); //32 chars
  static final _iv = IV.fromUtf8('put16characters!'); //16 chars

  /// Encrypt the data that is given
  static String encrypt(String text) {
    final e = Encrypter(AES(_key, mode: AESMode.cbc));
    final encryptedData = e.encrypt(text, iv: _iv);
    return encryptedData.base64;
  }

  /// Decrypt the data that is encrypted by this app Encrypt Function
  static String decrypt(String text) {
    final e = Encrypter(AES(_key, mode: AESMode.cbc));
    final decryptedData = e.decrypt(Encrypted.fromBase64(text), iv: _iv);
    return decryptedData;
  }
}
