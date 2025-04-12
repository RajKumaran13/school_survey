// lib/store/login_store.dart
import 'package:mobx/mobx.dart';
import 'package:school_survey/features/login_page/modal/login_api.dart';

part 'login_store.g.dart';

class LoginStore = _LoginStore with _$LoginStore;

abstract class _LoginStore with Store {
  final AuthApi _authApi = AuthApi();

  @observable
  String email = '';

  @observable
  String password = '';

  @observable
  String errorMessage = '';

  @observable
  bool isLoading = false;

  @action
  void setEmail(String value) => email = value;

  @action
  void setPassword(String value) => password = value;

  @action
  Future<bool> login() async {
    isLoading = true;
    try {
      await _authApi.login(email.trim(), password.trim());
      errorMessage = '';
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<bool> sendResetEmail(String resetEmail) async {
    try {
      await _authApi.sendPasswordResetEmail(resetEmail.trim());
      return true;
    } catch (e) {
      return false;
    }
  }
}
