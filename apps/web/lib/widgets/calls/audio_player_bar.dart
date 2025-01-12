import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lvm_telephony_web/gen/assets.gen.dart';
import 'package:lvm_telephony_web/utils/audio_stream_source.dart';
import 'package:lvm_telephony_web/utils/extensions/build_context.dart';
import 'package:common/controller/audio_player_controller.dart';
import 'package:domain/utils/extensions/duration_extension.dart';
import 'package:lvm_telephony_web/widgets/common/loader.dart';
import 'package:lvm_telephony_web/widgets/text/app_text.dart';

/// Плеер для проигрывания записи звонка
class AudioPlayerBar extends StatefulWidget {
  final String callId;
  final String projectId;

  const AudioPlayerBar({
    required this.callId,
    required this.projectId, 
    super.key, 
  });

  @override
  State<AudioPlayerBar> createState() => _AudioPlayerBarState();
}

class _AudioPlayerBarState extends State<AudioPlayerBar> {
  final _controller = GetIt.I<AudioPlayerController>();
  final _player = AudioPlayer();

  @override
  void initState() {
    _controller.init(projectId: widget.projectId, callId: widget.callId);
    _controller.recordStream.listen(_recordListener);
    _controller.recordStatusStream.listen(_statusListener);
    _controller.speedStream.listen(_speedListener);
    _controller.volumeStream.listen(_volumeListener);
    _controller.jumpStream.listen(_jumpListener);
    
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _player.setLoopMode(LoopMode.one);
    });

    super.initState();
  }

  Future<void> _recordListener(Uint8List record) async =>
    _player.setAudioSource(AudioStreamSource(record));
  
  Future<void> _statusListener(AudioPlayerStatus status) async => switch (status) {
    AudioPlayerStatus.running => _player.play(),
    _=> _player.pause(),
  };

  Future<void> _speedListener(double factor) async => _player.setSpeed(factor);

  Future<void> _volumeListener(double value) async => _player.setVolume(value);

  Future<void> _jumpListener(Duration timestamp) async => _player.seek(timestamp);

  void _onJump(double value) => _controller.jump(value);

  Future<void> _onToggle() async {
    if (!_controller.downloaded) await _controller.downloadAndRunRecord();
  
    _controller.toggle();
  }

  Future<void> _onSave() => _controller.saveRecord();  

  @override
  Future<void> dispose() async {
    _player.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Material(
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.theme.colorScheme.tertiary,
        boxShadow: [
          BoxShadow(
            color: context.theme.colorScheme.primaryContainer,
            blurRadius: 1,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          StreamBuilder<Duration?>(
            stream: _player.positionStream,
            builder: (context, value) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    AppText.bold(
                      context: context, 
                      text: value.data?.viewFormat ?? '00:00',
                      color: context.theme.colorScheme.tertiaryContainer,
                    ),
                    const Spacer(),
                    AppText.bold(
                      context: context, 
                      text: _player.duration?.viewFormat ?? '00:00',
                      color: context.theme.colorScheme.tertiaryContainer,
                    ),
                  ],
                ),
                Slider(
                    value: value.data?.inMilliseconds.toDouble() ?? 0.0, 
                    max: _player.duration?.inMilliseconds.toDouble() ?? 1.0,
                    divisions: 1000,
                    onChanged: _onJump,
                    inactiveColor: context.theme.colorScheme.outline,
                  ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Expanded(
                child: InkWell(
                  onTap: _onToggle,
                  child: Ink(
                    child: StreamBuilder<AudioPlayerStatus>(
                      stream: _controller.recordStatusStream, 
                      builder: (_, value) => switch (value.data) {
                          AudioPlayerStatus.running => Icon(
                            Icons.pause,
                            color: context.theme.colorScheme.primary,
                          ),
                          AudioPlayerStatus.failed => Icon(
                            Icons.error, 
                            color: context.theme.colorScheme.error,
                          ),
                          AudioPlayerStatus.loading => const AppLoader(size: 25),
                          _ => Icon(
                            Icons.play_arrow,
                            color: context.theme.colorScheme.primary,
                          ),
                        },
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Ink(
                    width: 25,
                    height: 25,
                    child: InkWell(
                      onTap: _onSave,
                      child: StreamBuilder<AudioSaveStatus>(
                        stream: _controller.saveStatusStream,
                        builder: (_, value) => switch (value.data) {
                          AudioSaveStatus.loading => const AppLoader(size: 20),
                          _ => Assets.icons.common.download.svg(
                            colorFilter: ColorFilter.mode(
                              context.theme.colorScheme.primary, 
                              BlendMode.srcIn,
                            ),
                          ),
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}