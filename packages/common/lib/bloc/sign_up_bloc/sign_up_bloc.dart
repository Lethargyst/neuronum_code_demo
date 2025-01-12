import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:equatable/equatable.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

/// Описание блока
@injectable
class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(const LoadingState()) {
    on<ExampleEvent>(_onExampleEvent);
  }

  void _onExampleEvent(ExampleEvent event, Emitter<SignUpState> emit) {}
}
