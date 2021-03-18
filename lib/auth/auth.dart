
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kishan_hub/model/user_model.dart';

abstract class BaseAuth {
  Future<String> signInEmailPassword(String email, String password);
  Future<String> signUpEmailPassword(User usuario);
  Future<void> signOut();
  Future<String> currentUser();
  
  Future<FirebaseUser> infoUser();
}

class Auth implements BaseAuth{
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> signInEmailPassword(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    return user.uid;
  }

  Future<String> signUpEmailPassword(User usuarioModel) async {
    FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(email: usuarioModel.email, password: usuarioModel.password);

    UserUpdateInfo usuario = UserUpdateInfo();
    usuario.displayName = usuarioModel.name;
    await user.updateProfile(usuario);
    await user.sendEmailVerification().then((value) => print('Verification email sent'))
          .catchError((onError )=> print('Verification email error: $onError')); 

    await Firestore.instance.collection('users').document('${user.uid}').setData({
      'Name' : usuarioModel.name,
      'MobileNo': usuarioModel.mobileno,
      'Email': usuarioModel.email,
      'City': usuarioModel.city,
    })
      .then((value) => print('User registered in the database'))
      .catchError((onError)=>print('Error in registering the user in the database'));
    return user.uid;
  }

  Future<String> currentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    String userId = user != null ? user.uid : 'no_login';
    return userId;
  }

  

  Future<FirebaseUser> infoUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    String userId = user !=null ? user.uid : 'User could not be retrieved';
    print('Retrieving user + $userId');
    return user;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  
}