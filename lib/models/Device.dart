import 'package:totp_app/encryption/encryption.dart';
import '../db/Database.dart';

class Device {
  String id;
  String deviceName;
  String devicePublicKey;
  String deviceLastSeen;
  bool deviceOnline;
  PublicKeyEncryptionHelper helper;

  Device({
    this.deviceName,
    this.deviceLastSeen,
    this.deviceOnline,
    this.devicePublicKey,
    this.id,
  }) {
    helper = new PublicKeyEncryptionHelper(this.devicePublicKey);
  }

  Future<void> sendToken(String token) async {
     final db = Database();
     print("Sending to deive");
     await db.sendToDevice(helper.encrypt(token), this);
     
  }

  Map<String, String> toMap() {
    return {
      "deviceName": this.deviceName,
      "devicePublicKey": this.devicePublicKey,
    };
  }

  Future<bool> save() async {
    final db = Database();
    return await db.saveDevice(this);
  }

  Future<void> delete() async {
    final db = Database();
    return await db.deleteDevice(this);
  }
}
