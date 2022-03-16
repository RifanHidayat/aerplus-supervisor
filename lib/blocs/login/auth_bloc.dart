
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:superviso/blocs/login/auth_event.dart';
import 'package:superviso/blocs/login/auth_state.dart';
import 'package:superviso/blocs/login/form_submission.dart';
import 'package:superviso/repositories/auth.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthState());

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    // TODO: implement mapEventToState
    //username updated
    if (event is AuthUsernameChange) {
      yield state.copyWith(username: event.username);

      //password updated
    } else if (event is AuthPasswordChange) {
      yield state.copyWith(password: event.password);

      //form submitted
    } else if (event is AuthSubmitted) {
      yield state.copyWith(formStatus: FormSubmitting());

      try {
        await authRepository.auth(username: state.username,password: state.password);
        yield state.copyWith(formStatus: SubmissionSuccess());
      } catch (e) {
        yield state.copyWith(formStatus: SubmissionFaied(e.toString()));
      }
    }
  }
  dispose(){

  }

}
