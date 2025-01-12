import 'dart:async';
import 'dart:typed_data';

import 'package:core/service/logger/logger.dart';
import 'package:domain/entity/common/file.dart';
import 'package:domain/usecase/calls/get_call_record_usecase.dart';
import 'package:domain/usecase/calls/save_call_record_usecase.dart';
import 'package:injectable/injectable.dart';

/// Статус аудио плеера
enum AudioPlayerStatus {
  running,
  stopped,
  loading,
  failed
}

enum AudioSaveStatus {
  loading,
  success,
  failure
}

/// Контроллер для управления аудио плеером
@injectable
final class AudioPlayerController {
  /// Юзкейс для получения записи
  final GetCallRecordUsecase _getCallRecordUsecase;

  /// Юзкейс для получения записи
  final SaveCallRecordUsecase _saveCallRecordUsecase;
  
  /// Логгер
  final AppLogger _logger;

  AudioPlayerController(
    this._getCallRecordUsecase, 
    this._saveCallRecordUsecase, 
    this._logger,
  );
  
  /// Аудиозапись
  FileEntity? _record;

  /// Стрим, возвращающий запись
  final _recordController = StreamController<Uint8List>.broadcast();
  Stream<Uint8List> get recordStream => _recordController.stream;

  /// Стрим, оповещающий о том, проигрывается ли запись
  AudioPlayerStatus _recordStatus = AudioPlayerStatus.stopped;
  final _recordStatusController = StreamController<AudioPlayerStatus>.broadcast();
  Stream<AudioPlayerStatus> get recordStatusStream => _recordStatusController.stream;

  /// Стрим, оповещающий о загрузке записи
  final _saveStatusController = StreamController<AudioSaveStatus>.broadcast();
  Stream<AudioSaveStatus> get saveStatusStream => _saveStatusController.stream;

  /// Стрим, оповещающий об изменении скорости аудио
  final _speedController = StreamController<double>.broadcast();
  Stream<double> get speedStream => _speedController.stream;

  /// Стрим, оповещающий об изменении громкости аудио
  final _volumeController = StreamController<double>.broadcast();
  Stream<double> get volumeStream => _volumeController.stream;

  /// Стрим, оповещающий об перемотке аудио
  final _jumpController = StreamController<Duration>.broadcast();
  Stream<Duration> get jumpStream => _jumpController.stream;

  late String projectId;
  late String callId;

  bool get downloaded => _record != null;

  void _run() => _recordStatusController.add(_recordStatus = AudioPlayerStatus.running);

  void _stop() => _recordStatusController.add(_recordStatus = AudioPlayerStatus.stopped);

  void init({required String projectId, required String callId}) {
    this.projectId = projectId;
    this.callId = callId;
  }

  Future<void> downloadAndRunRecord() async {
    _recordStatusController.add(AudioPlayerStatus.loading);

    await downloadRecord();

    if (!downloaded) {
      _recordStatusController.add(AudioPlayerStatus.failed);
      return;
    }
    _recordStatusController.add(AudioPlayerStatus.running);
  }

  Future<FileEntity?> downloadRecord() async {
    if (_record != null) return _record;

    _logger.info(message: 'AudioPlayer: Загрузка аудио (projectId: $projectId, callId: $callId)');

    final response = await _getCallRecordUsecase.call(projectId, callId);
    return response.fold(
      (l) => null, 
      (r) {
        _record = r;
        _recordController.add(_record!.content);
        return _record;
      } 
    );
  }

  // TODO: Добавить обработку ошибки
  Future<void> saveRecord() async {
    _saveStatusController.add(AudioSaveStatus.loading);

    final record = await downloadRecord();
    if (record != null) {
      await _saveCallRecordUsecase.call(record);
    }

    _saveStatusController.add(AudioSaveStatus.success);
  }
  
  void toggle() => switch (_recordStatus) {
      AudioPlayerStatus.running => _stop(),
      AudioPlayerStatus.stopped => _run(),
      _ => null
    };

  void setSpeed(double factor) => _speedController.add(factor);

  void setVolume(double value) => _volumeController.add(value);

  void jump(double timestamp) => _jumpController.add(Duration(milliseconds: timestamp.toInt()));

  Future<void> dispose() async {
    _recordController.close();
    _jumpController.close();
    _speedController.close();
    _recordStatusController.close();
    _saveStatusController.close();
    _volumeController.close();
  }
}