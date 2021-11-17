import 'package:dyphic/common/app_logger.dart';
import 'package:dyphic/model/app_exception.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

mixin AppAuthMixin {
  bool get isSignIn => FirebaseAuth.instance.currentUser != null;
  String? get uid => FirebaseAuth.instance.currentUser?.uid;
  String? get userName => FirebaseAuth.instance.currentUser?.displayName;
  String? get email => FirebaseAuth.instance.currentUser?.email;

  Future<void> signInWithGoogle() async {
    if (isSignIn) {
      AppLogger.d('すでにサインインしているので終了');
      return;
    }

    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      // サインインをキャンセルした場合はそのまま終了
      AppLogger.d('サインイン処理がキャンセルされたので終了');
      return;
    }

    try {
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      AppLogger.d('サインイン処理が完了しました。');
    } on PlatformException catch (e, s) {
      AppLogger.e('FirebaseAuth: サインイン処理でエラー', e, s);
      throw AppException(message: 'サインイン処理でプラットフォームのエラーが発生しました。', exception: e, stackTrace: s);
    } on FirebaseAuthException catch (e, s) {
      AppLogger.e('FirebaseAuth: サインイン処理でエラー', e, s);
      throw AppException(message: 'サインイン処理でFirebaseのエラーが発生しました。', exception: e, stackTrace: s);
    }
  }

  Future<void> logout() async {
    GoogleSignIn().disconnect();
    await FirebaseAuth.instance.signOut();
  }
}
