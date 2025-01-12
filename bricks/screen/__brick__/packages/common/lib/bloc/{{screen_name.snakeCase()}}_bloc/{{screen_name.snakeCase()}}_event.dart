part of '{{screen_name.snakeCase()}}_bloc.dart';

sealed class {{screen_name.pascalCase()}}Event extends Equatable {
  const {{screen_name.pascalCase()}}Event();
}

/// Описание ивента
class ExampleEvent extends {{screen_name.pascalCase()}}Event {
  @override
  List<Object?> get props => [];
}