import 'package:dyphic/service/app_firebase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final accountRepositoryProvider = Provider((ref) => _AccountRepository(ref.read));

class _AccountRepository {
  const _AccountRepository(this._read);

  final Reader _read;

  bool get isSignIn => _read(appFirebaseProvider).isSignIn;
  String? get userName => _read(appFirebaseProvider).userName;
  String? get userEmail => _read(appFirebaseProvider).email;

  Future<void> signIn() async {
    await _read(appFirebaseProvider).signInWithGoogle();
  }

  Future<void> signOut() async {
    await _read(appFirebaseProvider).logout();
  }
}
