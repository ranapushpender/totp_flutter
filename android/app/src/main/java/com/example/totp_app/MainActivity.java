package com.example.totp_app;
import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;
import javax.crypto.spec.SecretKeySpec;

import android.os.Bundle;
import android.util.Base64;

import java.security.SecureRandom;
import java.security.spec.KeySpec;
import java.util.ArrayList;
import java.util.List;

import io.flutter.Log;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    protected void onCreate(Bundle savedInstanceState){
        super.onCreate(savedInstanceState);
        //GeneratedPluginRegistrant.registerWith(getFlutterEngine());
        new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(),"com.flutter.epic/epic").setMethodCallHandler(
            new MethodCallHandler(){
                @Override
                public void onMethodCall(MethodCall call,Result result)
                {
                    if(call.method.equals("getResponse"))
                    {
                        result.success(101);
                    }
                    else if(call.method.equals("generateEncryptionKey"))
                    {
                        List<String> values = new ArrayList<String>();
                        String[] returned =generateEncryptionKey(call.argument("password").toString());
                        values.add(returned[0]);
                        values.add(returned[1]);
                        result.success(values);

//                        Log.d("Native Method",call.argument("username"));
                    }
                    else if(call.method.equals("getEncryptionKey")){
                        result.success(getEncryptionKey(call.argument("password").toString(),call.argument("salt").toString()));
                    }
                    else if(call.method.equals("decryptKey")){
                        result.success(decryptKey(call.argument("encKey").toString(),call.argument("masterKey").toString()));
                    }
                    else if(call.method.equals("encrypt")){
                        result.success(encryptToken(call.argument("token").toString(),call.argument("key").toString()));
                    }
                    else if(call.method.equals("decrypt")){
                        result.success(decryptToken(call.argument("token").toString(),call.argument("key").toString()));
                    }

                }
            }
        );
    }

    private int getResponse(){
        return 101;
    }

    private String getEncryptionKey(String password,String salt)
    {
        String encKey = "";
        try{
            if(android.os.Build.VERSION.SDK_INT >= 8) {
                int iterationCount = 100;
                int keyLength = 256;
                KeySpec spec = new PBEKeySpec(password.toCharArray(), android.util.Base64.decode(salt, Base64.URL_SAFE), iterationCount, keyLength);
                SecretKeyFactory factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");
                SecretKey encSecretKey = factory.generateSecret(spec);
                encKey = android.util.Base64.encodeToString(encSecretKey.getEncoded(), Base64.URL_SAFE);
            }
        }
        catch(Exception e)
        {
            Log.d("GetEncryptionKey",e.toString());
        }
        return encKey;
    }
    private String decryptKey(String encKey,String masterKey){
        String decrypted = "";
        try{
            if(android.os.Build.VERSION.SDK_INT >= 8){
                byte[] encKeyBytes = android.util.Base64.decode(encKey,Base64.URL_SAFE);
                byte[] masterKeyBytes = Base64.decode(masterKey,Base64.URL_SAFE);
                Cipher cipher = Cipher.getInstance("AES");
                SecretKeySpec encKeySpec = new SecretKeySpec(encKeyBytes,"AES");
                cipher.init(Cipher.DECRYPT_MODE,encKeySpec);
                byte[] cipherText = cipher.doFinal(masterKeyBytes);
                decrypted = Base64.encodeToString(cipherText,Base64.URL_SAFE);
            }
        }
        catch (Exception e){
            Log.d("DecryptKey",e.toString());
        }
        return decrypted;
    }
    private String[] generateEncryptionKey(String password)
    {
        byte[] binary = null;
        String result[]=new String[2];
        try{
            if(android.os.Build.VERSION.SDK_INT >= 8)
            {
                KeyGenerator gen = KeyGenerator.getInstance("AES");
                gen.init(256);
                SecretKey key = gen.generateKey();
                binary = key.getEncoded();
                Log.d("Original Master Key :",Base64.encodeToString(binary,Base64.URL_SAFE));

                byte[] salt = new byte[128];
                SecureRandom secureRandom = new SecureRandom();
                secureRandom.nextBytes(salt);

                byte[] encKey = android.util.Base64.decode(getEncryptionKey(password,android.util.Base64.encodeToString(salt, Base64.URL_SAFE)), Base64.URL_SAFE);

                Cipher cipher = Cipher.getInstance("AES");
                SecretKeySpec encKeySpec = new SecretKeySpec(encKey,"AES");
                cipher.init(Cipher.ENCRYPT_MODE,encKeySpec);
                byte[] cipherText = cipher.doFinal(binary);

                result[0] =  android.util.Base64.encodeToString(cipherText, Base64.URL_SAFE);
                result[1] = android.util.Base64.encodeToString(salt,Base64.URL_SAFE);
            }
            else{
                throw new UnsupportedOperationException();
            }
        }
        catch(Exception e)
        {
            System.out.println("Error"+e.toString());
        }
        return result;
    }

    private String encryptToken(String token,String encKey){
        String encrypted="";
        try{
            if(android.os.Build.VERSION.SDK_INT >= 8) {
                Cipher cipher = Cipher.getInstance("AES");
                SecretKeySpec encKeySpec = new SecretKeySpec(android.util.Base64.decode(encKey, Base64.URL_SAFE), "AES");
                cipher.init(Cipher.ENCRYPT_MODE, encKeySpec);
                byte[] encryptedBytes = cipher.doFinal(token.getBytes());
                encrypted = android.util.Base64.encodeToString(encryptedBytes, Base64.URL_SAFE);
            }
        }
        catch(Exception e){
            Log.d("EncryptToken",e.toString());
        }
        return encrypted;
    }

    private String decryptToken(String token,String encKey){
        String decrypted="";
        try{
            if(android.os.Build.VERSION.SDK_INT >= 8) {
                Cipher cipher = Cipher.getInstance("AES");
                SecretKeySpec secretKeySpec = new SecretKeySpec(android.util.Base64.decode(encKey, Base64.URL_SAFE), "AES");
                cipher.init(Cipher.DECRYPT_MODE, secretKeySpec);
                byte[] decryptedBytes = cipher.doFinal(android.util.Base64.decode(token, Base64.URL_SAFE));
                decrypted = new String(decryptedBytes);
            }
        }
        catch(Exception e){
            Log.d("DecryptToken",e.toString());
        }
        return decrypted;
    }


}
