import 'package:bloc/bloc.dart';
import 'package:common/gen/translations.g.dart';
import 'package:common/utils/validators.dart';
import 'package:domain/entity/request/sign_in_request.dart';
import 'package:domain/usecase/auth/sign_in_usecase.dart';
import 'package:injectable/injectable.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

/// Блок экрана авторизации
@injectable
class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final SignInUsecase _signInUsecase;

  SignInBloc(this._signInUsecase) : super(const SuccessState()) {
    on<EditLoginEvent>(_onEditLogin);
    on<EditPasswordEvent>(_onEditPassword);
    on<LoginEvent>(_onLogin);
  }

  /// Значение логина (email)
  String _login = "";

  /// Значение пароля
  String _password = "";

  /// Стрим, оповещающий об ошибке валидации почты
  final emailValidationError = BehaviorSubject<String?>.seeded(null);

  /// Стрим, оповещающий об ошибке валидации пароля
  final passwordValidationError = BehaviorSubject<String?>.seeded(null);

  void _onEditLogin(EditLoginEvent event, Emitter<SignInState> emit) {
    emailValidationError.add(null);
    _login = event.login.trim();
  }

  void _onEditPassword(EditPasswordEvent event, Emitter<SignInState> emit) {
    passwordValidationError.add(null);
    _password = event.password;
  }

  Future<void> _onLogin(LoginEvent event, Emitter<SignInState> emit) async {
    final isDataValid  = _validateData();
    if (!isDataValid) return;

    emit(const LoadingState());

    final result = await _signInUsecase.call(
      SignInRequest(login: _login, password: _password),
    );
    result.fold(
      (l) => emit(FailureState(l.message)), 
      (r) => emit(const SuccessState()),
    );
  }

  bool _validateData() {
    final emailError = Validators().validateEmail(_login);
    final passwordError = _password.isEmpty ? t.validators.emptyPassword : null;

    emailValidationError.add(emailError);
    passwordValidationError.add(passwordError);
    
    return emailError == null && passwordError == null;
  }
}
