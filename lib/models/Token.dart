import "package:flutter/material.dart";
class Token{
  final int id;
  final String email;
  final String website;
  final String token;

  Token({@required this.id,@required this.email,@required this.website,@required this.token});
   Map<String,dynamic> toMap()
   {
     return {"email":this.email,"website":this.website,"token":this.token,"id":this.id};
   }

  List<Token> toTokenList(Map<String,dynamic> tokenMap){
    
  }
}