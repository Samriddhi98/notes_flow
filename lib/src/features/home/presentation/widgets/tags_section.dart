import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../domain/entities/tag_entity.dart';
import '../bloc/note_editor_cubit/note_editor_cubit.dart';
import '../bloc/tags_bloc/tags_cubit.dart';

class TagsSection extends StatelessWidget {
  const TagsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteEditorCubit, NoteEditorState>(
      buildWhen: (a, b) {
        if (a is! NoteEditorReady || b is! NoteEditorReady) return true;
        return a.draft.tags != b.draft.tags;
      },
      builder: (context, state) {
        final attached = state is NoteEditorReady ? state.draft.tags : const <TagEntity>[];
        return Row(
          children: [
            Expanded(
              child: Wrap(
                spacing: 8.w,
                runSpacing: 4.h,
                children: [
                  for (final tag in attached)
                    Chip(
                      labelPadding: EdgeInsets.symmetric(horizontal: 8.w),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: const VisualDensity(horizontal: 0, vertical: -2),
                      backgroundColor: Colors.blue[50],
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      label: Text(
                        tag.name,
                        style: TextStyle(
                          color: Colors.blue[800],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      deleteIcon: Icon(
                        Icons.close,
                        size: 18.sp,
                        color: Colors.blue[700],
                      ),
                      onDeleted: () =>
                          context.read<NoteEditorCubit>().tagRemoved(tag.id),
                    ),
                ],
              ),
            ),
            TextButton(
              onPressed: () => _openTagPicker(context),
              child: const Text('+ Add tag'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _openTagPicker(BuildContext context) async {
    final tagsCubit = context.read<TagsCubit>();
    final editorCubit = context.read<NoteEditorCubit>();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetCtx) {
        return BlocProvider.value(
          value: tagsCubit,
          child: BlocProvider.value(
            value: editorCubit,
            child: const _TagPickerSheet(),
          ),
        );
      },
    );
  }
}

class _TagPickerSheet extends StatefulWidget {
  const _TagPickerSheet();

  @override
  State<_TagPickerSheet> createState() => _TagPickerSheetState();
}

class _TagPickerSheetState extends State<_TagPickerSheet> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _createAndAttach() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    final tag = await context.read<TagsCubit>().createTag(text);
    if (tag == null || !mounted) return;
    final editor = context.read<NoteEditorCubit>();
    final state = editor.state;
    final already = state is NoteEditorReady &&
        state.draft.tags.any((t) => t.id == tag.id);
    if (!already) editor.tagToggled(tag);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        top: 16.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16.h,
      ),
      child: BlocBuilder<TagsCubit, List<TagEntity>>(
        builder: (context, allTags) {
          return BlocBuilder<NoteEditorCubit, NoteEditorState>(
            builder: (context, editorState) {
              final selected = editorState is NoteEditorReady
                  ? editorState.draft.tags.map((t) => t.id).toSet()
                  : <String>{};
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tags',
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          textInputAction: TextInputAction.done,
                          decoration: const InputDecoration(
                            hintText: 'New tag',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                          onSubmitted: (_) => _createAndAttach(),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      ElevatedButton(
                        onPressed: _createAndAttach,
                        child: const Text('Add'),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  if (allTags.isEmpty)
                    Text(
                      'No tags yet. Create one above.',
                      style: TextStyle(color: Colors.black54, fontSize: 13.sp),
                    )
                  else
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 6.h,
                      children: [
                        for (final tag in allTags)
                          FilterChip(
                            label: Text(tag.name),
                            selected: selected.contains(tag.id),
                            onSelected: (_) =>
                                context.read<NoteEditorCubit>().tagToggled(tag),
                          ),
                      ],
                    ),
                  SizedBox(height: 8.h),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Done'),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}