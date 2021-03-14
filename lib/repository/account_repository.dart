import 'package:dyphic/service/app_firebase.dart';

class AccountRepository {
  const AccountRepository._(this._appFirebase);

  factory AccountRepository.create() {
    return AccountRepository._(AppFirebase.instance);
  }

  final AppFirebase _appFirebase;
  bool get isLogIn => _appFirebase.isLogIn;
  String? get userName => _appFirebase.userName;
  String? get userEmail => _appFirebase.email;

  Future<void> login() async {
    await _appFirebase.login();
  }

  Future<void> logout() async {
    await _appFirebase.logout();
  }
}
