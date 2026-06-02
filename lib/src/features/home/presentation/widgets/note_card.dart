import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../domain/entities/note_media_entity.dart';
import '../../domain/entities/notes_entity.dart';

class NoteCard extends StatelessWidget {
  final NotesEntity note;
  final VoidCallback onTap;
  final VoidCallback onPinToggle;

  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    required this.onPinToggle,
  });

  @override
  Widget build(BuildContext context) {
    final imageCount = note.media.where((m) => m.type == MediaType.image).length;
    final voiceCount = note.media.where((m) => m.type == MediaType.voice).length;
    final todoTotal = note.todos.length;
    final todoDone = note.todos.where((t) => t.isDone).length;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.black12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    (note.title?.trim().isNotEmpty ?? false) ? note.title! : 'Untitled',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: Icon(
                    note.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                    size: 18.sp,
                    color: note.isPinned ? Colors.blue : Colors.black45,
                  ),
                  onPressed: onPinToggle,
                ),
              ],
            ),
            if ((note.content?.trim().isNotEmpty ?? false)) ...[
              SizedBox(height: 4.h),
              Text(
                note.content!,
                style: TextStyle(fontSize: 13.sp, color: Colors.black54),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            if (note.tags.isNotEmpty) ...[
              SizedBox(height: 8.h),
              Wrap(
                spacing: 6.w,
                runSpacing: 4.h,
                children: [
                  for (final tag in note.tags)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        tag.name,
                        style: TextStyle(
                          color: Colors.blue[800],
                          fontWeight: FontWeight.w500,
                          fontSize: 11.sp,
                        ),
                      ),
                    ),
                ],
              ),
            ],
            if (imageCount > 0 || voiceCount > 0 || todoTotal > 0) ...[
              SizedBox(height: 8.h),
              Row(
                children: [
                  if (imageCount > 0)
                    _Indicator(icon: Icons.image_outlined, label: '$imageCount'),
                  if (voiceCount > 0) ...[
                    SizedBox(width: 10.w),
                    _Indicator(icon: Icons.mic_none, label: '$voiceCount'),
                  ],
                  if (todoTotal > 0) ...[
                    SizedBox(width: 10.w),
                    _Indicator(
                      icon: Icons.check_box_outlined,
                      label: '$todoDone/$todoTotal',
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Indicator extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Indicator({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14.sp, color: Colors.black54),
        SizedBox(width: 3.w),
        Text(label, style: TextStyle(fontSize: 11.sp, color: Colors.black54)),
      ],
    );
  }
}
