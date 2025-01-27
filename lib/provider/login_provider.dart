import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
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

  Future<void> loginWithApple() async {
    loading = true;

    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );
      await FirebaseAuth.instance.signInWithCredential(oauthCredential);
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
  }

  Future<UserCredential> loginWithGoogle() async {
    late UserCredential userCredential;
    loading = true;

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn(
              clientId: Platform.isIOS
                  ? "1052229586554-g7tm8tqpjq242hmphomb1hn9bejqa26r.apps.googleusercontent.com"
                  : "1052229586554-sfgsc4r16hsce5l5f4d4rrrc2cu24lqg.apps.googleusercontent.com")
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

  bool get isLoggedIn {
    return FirebaseAuth.instance.currentUser != null;
  }

  Player get getUserData {
    Player player;
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final String emailName = user.email!.split("@")[0];
      player = Player(
        user.displayName ?? emailName,
        user.uid,
        user.photoURL ??
            "https://placehold.co/400x400/orange/white/png?text=${emailName[0]}",
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
