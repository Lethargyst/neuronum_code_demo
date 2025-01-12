part of 'current_call_bloc.dart';

final class CurrentCallState extends Equatable {
  final Call? curCall;

  const CurrentCallState({ this.curCall });

  CurrentCallState copyWith({
    Call? curCall,
  })
    => CurrentCallState(
      curCall: curCall ?? this.curCall,
    );

  @override
  List<Object?> get props => [curCall];
}