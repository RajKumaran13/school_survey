// lib/store/register_store.dart
import 'package:mobx/mobx.dart';
import 'package:school_survey/features/register_page/model/register_api.dart';

part 'register_store.g.dart';

class RegisterStore = _RegisterStore with _$RegisterStore;

abstract class _RegisterStore with Store {
  final AuthApi _authApi = AuthApi();

  @observable
  String name = '';

  @observable
  String mobile = '';

  @observable
  String email = '';

  @observable
  String password = '';

  @observable
  String confirmPassword = '';

  @observable
  bool isLoading = false;

  @computed
  bool get passwordsMatch => password == confirmPassword && password.isNotEmpty;

  @computed
  bool get allFieldsValid =>
      name.isNotEmpty &&
      mobile.isNotEmpty &&
      email.isNotEmpty &&
      password.isNotEmpty &&
      passwordsMatch;

  @action
  void setName(String value) => name = value;

  @action
  void setMobile(String value) => mobile = value;

  @action
  void setEmail(String value) => email = value;

  @action
  void setPassword(String value) => password = value;

  @action
  void setConfirmPassword(String value) => confirmPassword = value;

  @action
Future<bool> registerUser() async {
  isLoading = true;
  try {
    final user = await _authApi.registerUser(
      name: name,
      email: email,
      mobile: mobile,
      password: password,
    );
    return user != null;
  } catch (e) {
    print('❌ Registration error: $e');
    return false;
  } finally {
    isLoading = false;
  }
}
}
