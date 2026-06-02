import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:uuid/uuid.dart';

class VoiceRecording {
  final String path;
  final int durationMs;
  const VoiceRecording({required this.path, required this.durationMs});
}

class VoiceRecorderSheet extends StatefulWidget {
  const VoiceRecorderSheet({super.key});

  static Future<VoiceRecording?> show(BuildContext context) {
    return showModalBottomSheet<VoiceRecording>(
      context: context,
      isDismissible: false,
      enableDrag: false,
      builder: (_) => const VoiceRecorderSheet(),
    );
  }

  @override
  State<VoiceRecorderSheet> createState() => _VoiceRecorderSheetState();
}

class _VoiceRecorderSheetState extends State<VoiceRecorderSheet> {
  final _recorder = AudioRecorder();
  Timer? _ticker;
  Duration _elapsed = Duration.zero;
  bool _recording = false;
  String? _path;

  @override
  void initState() {
    super.initState();
    _start();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _recorder.dispose();
    super.dispose();
  }

  Future<void> _start() async {
    if (!await _recorder.hasPermission()) {
      if (mounted) Navigator.pop(context, null);
      return;
    }
    final dir = await getTemporaryDirectory();
    final path = '${dir.path}/${const Uuid().v4()}.m4a';
    await _recorder.start(const RecordConfig(), path: path);
    setState(() {
      _recording = true;
      _path = path;
      _elapsed = Duration.zero;
    });
    _ticker = Timer.periodic(const Duration(milliseconds: 200), (t) {
      if (mounted) setState(() => _elapsed += const Duration(milliseconds: 200));
    });
  }

  Future<void> _stopAndConfirm() async {
    _ticker?.cancel();
    final result = await _recorder.stop();
    final path = result ?? _path;
    if (!mounted) return;
    if (path == null) {
      Navigator.pop(context, null);
      return;
    }
    Navigator.pop(
      context,
      VoiceRecording(path: path, durationMs: _elapsed.inMilliseconds),
    );
  }

  Future<void> _cancel() async {
    _ticker?.cancel();
    if (_recording) {
      await _recorder.cancel();
      if (_path != null) {
        try {
          File(_path!).deleteSync();
        } catch (_) {}
      }
    }
    if (mounted) Navigator.pop(context, null);
  }

  String get _timeLabel {
    final m = _elapsed.inMinutes.toString().padLeft(2, '0');
    final s = (_elapsed.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.mic, size: 48.sp, color: Colors.red),
            SizedBox(height: 12.h),
            Text(
              _recording ? 'Recording…' : 'Preparing…',
              style: TextStyle(fontSize: 14.sp, color: Colors.black54),
            ),
            SizedBox(height: 8.h),
            Text(
              _timeLabel,
              style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(onPressed: _cancel, child: const Text('Cancel')),
                ElevatedButton.icon(
                  onPressed: _recording ? _stopAndConfirm : null,
                  icon: const Icon(Icons.stop),
                  label: const Text('Stop & Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}