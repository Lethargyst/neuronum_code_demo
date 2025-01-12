import 'package:domain/entity/comment/comment.dart';
import 'package:domain/entity/response/tag.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'call.freezed.dart';

/// Сущность параметров звонка
@freezed
class CallData with _$CallData  {
  const factory CallData({
    /// Номер телефона клиента
    String? phoneNumber,

    /// Услуга
    String? service,

    /// Имя клиента
    String? clientName,

    /// Имя администратора
    String? adminName,

    /// Виртуальный номер клиента
    String? virtualNumber,

    /// Статус записи клиента
    String? recordStatus,

    /// Обращался ли клиент до этого
    String? visitedBefore,
    
    /// Комментарии к звонку
    List<CommentEntity>? comments,
    
    /// Входящий ли звонок
    bool? isIncoming,
  }) = _CallData;
}

/// Сущность звонка
@freezed
class Call with _$Call {
  const factory Call({
    /// Дополнительные параметры звонка
    required CallData callData,

    /// Айди звонка
    required String id,

    /// Айди проекта
    required String projectId,

    /// Текст звонка
    required String text,

    /// Дата и время звонка
    required DateTime dateTime,

    /// Теши звонка
    required List<TagEntity> tags,

    /// Текст анализа отказа в записи
    String? refuseAnalytics,

    /// Текст анализа звонка
    String? callAnalytics,

    /// Текст анализа работы администратора
    String? adminAnalytics,

  }) = _Call;
}

extension CallHelper on Call {
  Call updateComment(CommentEntity newComment) {
    final comments = callData.comments != null
      ? [...callData.comments!]
      : <CommentEntity>[];
    
    for (var i = 0; i < comments.length; i++) {
      final comment = comments[i];
      if (comment.userId == newComment.userId) {
        comments[i] = newComment;
      }
    }

    if (comments.isEmpty) comments.add(newComment);

    return copyWith(
      callData: callData.copyWith(
        comments: comments,
      ),
    );
  }
}
