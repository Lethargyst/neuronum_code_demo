import 'package:bloc/bloc.dart';
import 'package:domain/usecase/calls/delete_comment_usecase.dart';
import 'package:domain/usecase/calls/edit_comment_usecase.dart';
import 'package:injectable/injectable.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

part 'comment_event.dart';
part 'comment_state.dart';

/// Блок редактирования комментария
@injectable
class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final EditCommentUsecase _editCommentUsecase;
  final DeleteCommentUsecase _deleteCommentUsecase;

  CommentBloc(this._editCommentUsecase, this._deleteCommentUsecase) 
    : super(const CommonState(comment: '')) {
      on<StartEditingEvent>(_onStartEditing);
      on<StopEditingEvent>(_onStopEditing);
      on<DeleteCommentEvent>(_onDeleteComment);
      on<EditCommentEvent>(_onEditComment);
      on<SaveEvent>(_onSave);
    }

  late String _comment;
  late String _projectId;
  late String _callId;

  String initialComment = '';

  /// Стрим, оповещающий об ошибке валидации почты
  final validationError = BehaviorSubject<bool>.seeded(false);

  void init({required String projectId, required String callId, required String? comment}) {
    _comment = comment ?? '';
    initialComment = _comment;
    _projectId = projectId;
    _callId = callId;

    validationError.add(initialComment.isEmpty);
  }

  void _onStartEditing(StartEditingEvent event, Emitter<CommentState> emit) => 
    emit(EditingState(comment: _comment, status: CommentStatus.success));

  void _onStopEditing(StopEditingEvent event, Emitter<CommentState> emit) {
    _comment = initialComment;
    emit(CommonState(comment: _comment));
  }

  void _onEditComment(EditCommentEvent event, Emitter<CommentState> emit) {
    _comment = event.comment;
    _validateData();
  }

  Future<void> _onDeleteComment(DeleteCommentEvent event, Emitter<CommentState> emit) async {
    final curState = state as EditingState;
    emit(curState.copyWith(status: CommentStatus.loading));

    final result = await _deleteCommentUsecase.call(
      projectId: _projectId,
      callId: _callId,
    );
    result.fold(
      (l) => emit(curState.copyWith(status: CommentStatus.failure)), 
      (r) {
        _comment = '';
        initialComment = '';
        emit(const CommonState(comment: ''));
      },
    );
  }

  Future<void> _onSave(SaveEvent event, Emitter<CommentState> emit) async {
    final curState = state as EditingState;
    emit(curState.copyWith(status: CommentStatus.loading));

    final result = await _editCommentUsecase.call(
      projectId: _projectId,
      callId: _callId,
      comment: _comment,
    );
    result.fold(
      (l) => emit(curState.copyWith(status: CommentStatus.failure)), 
      (r) {
        initialComment = _comment;
        emit(CommonState(comment: _comment));
      }
    );
  }

  void _validateData() => validationError.add(_comment.isEmpty || _comment.length > 5000);

  @override
  Future<void> close() async {
    validationError.close();
    super.close();
  }
}
