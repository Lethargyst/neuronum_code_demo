import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:equatable/equatable.dart';

part '{{screen_name.snakeCase()}}_event.dart';
part '{{screen_name.snakeCase()}}_state.dart';

/// Описание блока
@injectable
class {{screen_name.pascalCase()}}Bloc extends Bloc<{{screen_name.pascalCase()}}Event, {{screen_name.pascalCase()}}State> {
  {{screen_name.pascalCase()}}Bloc() : super(const LoadingState()) {
    on<ExampleEvent>(_onExampleEvent);
  }

  void _onExampleEvent(ExampleEvent event, Emitter<{{screen_name.pascalCase()}}State> emit) {}
}
