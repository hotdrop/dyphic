import 'package:dyphic/service/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final accountRepositoryProvider = Provider((ref) => _AccountRepository(ref));

class _AccountRepository {
  const _AccountRepository(this._ref);

  final Ref _ref;

  bool get isSignIn => _ref.read(firebaseAuthProvider).isSignIn;
  String? get userName => _ref.read(firebaseAuthProvider).userName;
  String? get userEmail => _ref.read(firebaseAuthProvider).email;

  Future<void> signIn() async {
    await _ref.read(firebaseAuthProvider).signInWithGoogle();
  }

  Future<void> signOut() async {
    await _ref.read(firebaseAuthProvider).signOutWithGoogle();
  }
}
