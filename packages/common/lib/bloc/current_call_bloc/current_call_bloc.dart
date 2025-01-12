import 'package:bloc/bloc.dart';
import 'package:common/gen/translations.g.dart';
import 'package:domain/entity/comment/comment.dart';
import 'package:domain/entity/common/call/call.dart';
import 'package:domain/storage/user_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

part 'current_call_event.dart';
part 'current_call_state.dart';

/// Блок выбранного звонка
@injectable
class CurrentCallBloc extends Bloc<CurrentCallEvent, CurrentCallState> {
  final UserStorage _userStorage;

  CurrentCallBloc(this._userStorage) : super(const CurrentCallState()) {
    on<PickCallEvent>(_onPickCall);
    on<ClearEvent>(_onClearEvent);
    on<SaveCommentEvent>(_onSaveComment);
  }

  final _callEditsController = BehaviorSubject<Call>();
  Stream<Call> get callEditsStream => _callEditsController.stream;

  void _onPickCall(PickCallEvent event, Emitter<CurrentCallState> emit) => 
    emit(state.copyWith(curCall: event.call));

  void _onClearEvent(ClearEvent event, Emitter<CurrentCallState> emit) => 
    emit(const CurrentCallState());

  void _onSaveComment(SaveCommentEvent event, Emitter<CurrentCallState> emit) {
    if (state.curCall == null) return;

    final user = _userStorage.user;
    if (user == null) throw Exception(t.errors.wrongAuthData);
    
    final comment = CommentEntity(
      userId: user.id,
      userName: user.name ?? '', 
      value: event.comment,
    );

    final updatedCall = state.curCall!.updateComment(comment);

    emit(
      state.copyWith(
        curCall: updatedCall,
      ),
    );

    _callEditsController.add(updatedCall);
  }

  @override
  Future<void> close() {
    _callEditsController.close();
    return super.close();
  }
}
