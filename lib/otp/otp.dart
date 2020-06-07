import "../encryption/encryption.dart";

class AppOTP{
  EncryptionHelper helper;
  StringBuffer otpString;

  AppOTP({this.otpString}){}

  Future<void> encryptString() async{
    helper = await EncryptionHelper.createHelper();
    if(helper==null){
      print("Could Not initialize helper");
      throw Exception("Uninitlialed Helper");
    }
    else{
      var encyptedString  = await helper.encrypt(otpString.toString());
      otpString.clear();
      otpString = new StringBuffer(encyptedString);
    }
    
  }

  Future<StringBuffer> get decryptedString async{
    helper = await EncryptionHelper.createHelper();
    print("I have encrypted otp : ${otpString}");
    return StringBuffer((await helper.decrypt(this.otpString.toString())));
  }

  Map<String,String> toMap(){
    return {
      "otpString" : this.otpString.toString(),
    };
  }
  Future<String> get decryptedOTPString async{
    var decStr = await helper.decrypt(this.otpString.toString());
    print("Decrypted : $decStr");
    return await helper.decrypt(this.otpString.toString());
  }

  
}