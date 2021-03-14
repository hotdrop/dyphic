import 'package:dyphic/common/app_logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

mixin AppAuthMixin {
  User? _user;

  Future<void> initAuth() async {
    if (_user != null) {
      return;
    }
    await Firebase.initializeApp();
    _user = FirebaseAuth.instance.currentUser;
  }

  bool get isLogIn => _user != null;

  String? get userName => _user?.displayName;
  String? get email => _user?.email;

  Future<void> login() async {
    User? currentUser = _user ?? FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      AppLogger.d('Googleアカウントのサインイン: 既にユーザー情報が保持できているのでサインイン完了');
      return;
    }

    AppLogger.d('Googleアカウントのサインイン: ユーザー情報がないのでGoogleアカウントでサインインします　');
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      return;
    }

    try {
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
      final authResult = await FirebaseAuth.instance.signInWithCredential(credential);
      _user = authResult.user;
      AppLogger.d('Googleアカウントのサインイン: サインイン完了');
    } on PlatformException catch (e, s) {
      await AppLogger.e('FirebaseAuth: ログイン処理でエラー code=${e.code}', e, s);
      rethrow;
    } on FirebaseAuthException catch (e, s) {
      await AppLogger.e('FirebaseAuth: ログイン処理でエラー code=${e.code}', e, s);
      rethrow;
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    _user = null;
  }
}
