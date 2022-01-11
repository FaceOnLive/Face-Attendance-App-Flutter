import 'package:encrypt/encrypt.dart';

/// This is used for QR Code to generate an encrypted that can only be
/// understood by this FaceAttendance app, so that no one gets the real
/// data of the user that is being shared.
class AppAlgorithmUtil {
  static final _key =
      Key.fromUtf8('ajkjhy9mvmohvjsvlminkqapwuzfwjmz'); //32 chars
  static final _iv = IV.fromUtf8('qelioqmominqwdgi'); //16 chars

  /// Encrypt the data that is given. uses [AppAlgorithmUtil]
  static String encrypt(String text) {
    final e = Encrypter(AES(_key, mode: AESMode.cbc));
    final encryptedData = e.encrypt(text, iv: _iv);
    return encryptedData.base64;
  }

  /// Decrypt the data that was encrypted by the app. uses [AppAlgorithmUtil]
  static String decrypt(String text) {
    final e = Encrypter(AES(_key, mode: AESMode.cbc));
    final decryptedData = e.decrypt(Encrypted.fromBase64(text), iv: _iv);
    return decryptedData;
  }
}
