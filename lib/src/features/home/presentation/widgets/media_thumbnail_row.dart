import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../domain/entities/note_media_entity.dart';
import '../bloc/note_editor_cubit/note_editor_cubit.dart';

class MediaThumbnailRow extends StatelessWidget {
  const MediaThumbnailRow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteEditorCubit, NoteEditorState>(
      buildWhen: (a, b) {
        if (a is! NoteEditorReady || b is! NoteEditorReady) return true;
        return a.draft.media != b.draft.media;
      },
      builder: (context, state) {
        if (state is! NoteEditorReady) return const SizedBox.shrink();
        final media = state.draft.media;
        if (media.isEmpty) return const SizedBox.shrink();
        return SizedBox(
          height: 80.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: media.length,
            separatorBuilder: (context, index) => SizedBox(width: 8.w),
            itemBuilder: (context, i) {
              final m = media[i];
              return GestureDetector(
                onLongPress: () =>
                    context.read<NoteEditorCubit>().mediaRemoved(m.id),
                child: m.type == MediaType.image
                    ? _ImageTile(path: m.storagePath)
                    : _VoiceTile(path: m.storagePath, durationMs: m.durationMs),
              );
            },
          ),
        );
      },
    );
  }
}

class _ImageTile extends StatelessWidget {
  final String path;
  const _ImageTile({required this.path});

  @override
  Widget build(BuildContext context) {
    final file = File(path);
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.r),
      child: SizedBox(
        width: 80.w,
        height: 80.w,
        child: file.existsSync()
            ? Image.file(file, fit: BoxFit.cover)
            : Container(
                color: Colors.black12,
                child: const Icon(Icons.broken_image, color: Colors.black38),
              ),
      ),
    );
  }
}

class _VoiceTile extends StatefulWidget {
  final String path;
  final int? durationMs;
  const _VoiceTile({required this.path, this.durationMs});

  @override
  State<_VoiceTile> createState() => _VoiceTileState();
}

class _VoiceTileState extends State<_VoiceTile> {
  final _player = AudioPlayer();
  bool _playing = false;

  @override
  void initState() {
    super.initState();
    _player.onPlayerComplete.listen((_) {
      if (mounted) setState(() => _playing = false);
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _toggle() async {
    if (_playing) {
      await _player.pause();
      setState(() => _playing = false);
    } else {
      await _player.play(DeviceFileSource(widget.path));
      setState(() => _playing = true);
    }
  }

  String get _label {
    final ms = widget.durationMs;
    if (ms == null) return 'Voice';
    final s = (ms / 1000).round();
    final mm = (s ~/ 60).toString().padLeft(2, '0');
    final ss = (s % 60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _toggle,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        width: 110.w,
        height: 80.w,
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _playing ? Icons.pause_circle_filled : Icons.play_circle_filled,
              size: 28.sp,
              color: Colors.blue[800],
            ),
            SizedBox(width: 6.w),
            Text(
              _label,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.blue[800],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
