import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tic_tac_toe/model/player.dart';

class LoginProvider with ChangeNotifier {
  bool _showLoading = false;

  bool get loading {
    return _showLoading;
  }

  set loading(bool v) {
    _showLoading = v;
    notifyListeners();
  }

  Future<UserCredential> loginWithGoogle() async {
    loading = true;
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    loading = false;

    // add user to firestore database
    FirebaseFirestore.instance.collection("users").add(getUserData.toDbJson());

    return userCredential;
  }

  logout() async {
    loading = true;
    await FirebaseAuth.instance.signOut();
    loading = false;
  }

  Player get getUserData {
    final user = FirebaseAuth.instance.currentUser;
    Player player = Player(
      user!.displayName!,
      user.uid,
      user.photoURL!,
    );

    return player;
  }

  Future<Player> getUserById(String id) async {
    QuerySnapshot data = await FirebaseFirestore.instance
        .collection("users")
        .where("playerId", isEqualTo: id)
        .get();
    Player player = Player.fromJson(data.docs.first.data());
    print(player.name);

    return player;
  }
}
