import 'package:firebase_auth/firebase_auth.dart';

class Users {
  late String id;

  Users.fromFirebase(User user){
    id = user.uid;
  }
}