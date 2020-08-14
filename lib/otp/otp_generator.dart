import "../models/Token.dart";
import "package:otp/otp.dart";
import "dart:convert";
import "package:base32/base32.dart";

class OTPGenerator {
  Token token;
  OTPGenerator({this.token});

  String generateToken() {
    String generatedToken = "000 000";
    try {
      var cdate = DateTime.now();
      switch (token.type) {
        case TokenTypes.TOTP:
          print("I am totp ${token.secret} ${token.period} ${token.algorithm}");
          print(OTP.generateTOTPCodeString("JBSWY3DPEHPK3PXP", 1362302550000));
          generatedToken = OTP.generateTOTPCodeString(
            token.secret.toString(),
            DateTime.now().millisecondsSinceEpoch,
            interval: token.period != null ? token.period : 30,
            length: 6,
            algorithm:
                token.algorithm != null ? token.algorithm : Algorithm.SHA1,
          );
          break;
        case TokenTypes.HOTP:
          generatedToken = OTP.generateHOTPCodeString(
            token.secret.toString(),
            token.counter,
            algorithm:
                (token.algorithm != null ? token.algorithm : Algorithm.SHA1),
          );
          break;
      }
    } catch (e) {
      generatedToken = "INVALID";
      print(e);
    }
    return generatedToken;
  }
}
