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
          generatedToken = OTP.generateTOTPCodeString(
            token.secret.toString() ,
            cdate.toUtc().millisecondsSinceEpoch,
            interval: token.period != null ? token.period : 30,
            length: 6,
            algorithm:
                token.algorithm != null ? token.algorithm : Algorithm.SHA256,
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
