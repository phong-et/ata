import 'package:encrypt/encrypt.dart';
void decrypt(String qrCode){
  final plainTextBase64 = qrCode;
  final key = Key.fromUtf8('aA123Bb321@8*iPg');
  final iv = IV.fromUtf8('aA123Bb321@8*iPg');
  final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
  String decrypted = encrypter.decrypt64(plainTextBase64, iv: iv);
  print(decrypted);
}
void main() {
  final plainText = 'localhost:51457_132297733869805640';
  final key = Key.fromUtf8('aA123Bb321@8*iPg');
  final iv = IV.fromUtf8("aA123Bb321@8*iPg");
  final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
  final encrypted = encrypter.encrypt(plainText, iv: iv);
  final decrypted = encrypter.decrypt(encrypted, iv: iv);
  final decryptedFromBase64String = encrypter.decrypt64(encrypted.base64, iv: iv);
  print('plainText: $plainText');
  print('key: ${key.base64.toString()}');
  print('iv: ${iv.base64}');
  print('encrypted.base64: ${encrypted.base64}');
  print('plainText: $decrypted');
  print('decryptedFromBase64String: $decryptedFromBase64String');
  
  decrypt('7Z9Qh7HALyRKRWJeBthLgDsHpWX5BFv3+U1aF3K+uQ86fmmRQAsQQpmTSgvAmjtb');
  decrypt('1dupIdia0B/NX1ZL7HZps6pTkOx3FmrJYqQNaBr0WQ0=');
}