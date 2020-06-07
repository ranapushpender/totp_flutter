import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class DeviceStorage{
  final storage = new FlutterSecureStorage();

  Future<void> saveEncryptionKey(StringBuffer key) async {
    await storage.write(key: "totpEncryptionKey", value: key.toString());
  }
  Future<StringBuffer> getEncryptionKey() async {
    return StringBuffer(await storage.read(key: "totpEncryptionKey"));
  }

  Future<bool> deleteEncryptionKey() async {
    await storage.delete(key: "totpEncrytionKey");
    return true;
  }
}