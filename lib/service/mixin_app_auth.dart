import 'package:dyphic/common/app_logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

mixin AppAuthMixin {
  User _user;

  Future<void> initAuth() async {
    if (_user != null) {
      return;
    }
    await Firebase.initializeApp();
    _user = FirebaseAuth.instance.currentUser;
  }

  bool get isLogIn => _user != null;

  String get uid => _user.uid;
  String get userName => _user.displayName;
  String get email => _user.email;

  Future<void> login() async {
    final currentUser = _user ?? FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      AppLogger.d('Googleへのサインイン: 既にユーザー情報が保持できているのでサインイン完了');
      return currentUser;
    }

    AppLogger.d('Googleへのサインイン: ユーザー情報がないのでGoogleアカウントでサインインします　');
    final googleUser = await GoogleSignIn().signIn();
    final googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );

    final authResult = await FirebaseAuth.instance.signInWithCredential(credential);
    _user = authResult.user;
    AppLogger.d('Googleへのサインイン: サインイン完了');
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    _user = null;
  }
}
