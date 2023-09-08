import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tic_tac_toe/constants.dart';
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
    late UserCredential userCredential;
    loading = true;

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn(
          clientId:
          "1052229586554-sfgsc4r16hsce5l5f4d4rrrc2cu24lqg.apps.googleusercontent.com")
          .signIn();
      final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

      Future.delayed(const Duration(milliseconds: 100));
      // add user to firestore database
      Player player = getUserData;
      FirebaseFirestore.instance
          .collection("users")
          .doc(player.playerId)
          .set(player.toDbJson());
    } finally {
      loading = false;
    }

    return userCredential;
  }

  logout() async {
    loading = true;
    await FirebaseAuth.instance.signOut();
    loading = false;
  }

  Player get getUserData {
    Player player;
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      player = Player(
        user.displayName!,
        user.uid,
        user.photoURL!,
      );
    } else {
      player = Player(
        "John Doe",
        "123456789",
        imageUrl,
      );
    }

    return player;
  }

  Future<Player> getUserById(String id) async {
    QuerySnapshot data = await FirebaseFirestore.instance
        .collection("users")
        .where("playerId", isEqualTo: id)
        .get();
    Player player = Player.fromJson(data.docs.first.data());

    return player;
  }
}
