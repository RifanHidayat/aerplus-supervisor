

import 'package:superviso/blocs/login/form_submission.dart';

class AuthState {
  final String username;

  bool get isValidUsername => username.length > 3;
  final String password;

  bool get isValidPassword => password.length > 6;
  final FormSubmissionStatus formStatus;

  AuthState(
      {this.username = '',
        this.password = '',
        this.formStatus = const InitialFormStatus()});

  AuthState copyWith(
      {String? username, String? password, FormSubmissionStatus? formStatus}) {
    return AuthState(
        username: username ?? this.username,
        password: password ?? this.password,
        formStatus: formStatus ?? this.formStatus);
  }
}
