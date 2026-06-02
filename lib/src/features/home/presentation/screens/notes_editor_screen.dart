import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes_flow/src/core/di/injector.dart';
import 'package:notes_flow/src/core/extensions/build_context.dart';
import 'package:notes_flow/src/core/widgets/custom_text_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/note_media_entity.dart';
import '../../domain/entities/notes_entity.dart';
import '../bloc/note_editor_cubit/note_editor_cubit.dart';
import '../bloc/notes_bloc.dart';
import '../widgets/media_thumbnail_row.dart';
import '../widgets/tags_section.dart';
import '../widgets/todo_list_editor.dart';
import '../widgets/voice_recorder_sheet.dart';

@RoutePage()
class NoteEditorScreen extends StatelessWidget {
  final String? noteId;

  const NoteEditorScreen({super.key, this.noteId});

  @override
  Widget build(BuildContext context) {
    final notesState = context.read<NotesBloc>().state;
    NotesEntity? existing;
    if (noteId != null && notesState is NotesLoaded) {
      try {
        existing = notesState.notes.firstWhere((n) => n.id == noteId);
      } catch (_) {
        existing = null;
      }
    }
    final userId = Supabase.instance.client.auth.currentUser?.id ?? '';
    return BlocProvider(
      create: (_) =>
          getIt<NoteEditorCubit>()..initFor(existing, userId: userId),
      child: const _EditorView(),
    );
  }
}

class _EditorView extends StatefulWidget {
  const _EditorView();

  @override
  State<_EditorView> createState() => _EditorViewState();
}

class _EditorViewState extends State<_EditorView> {
  late final TextEditingController _titleController;
  late final TextEditingController _bodyController;

  @override
  void initState() {
    super.initState();
    final state = context.read<NoteEditorCubit>().state;
    final draft = state is NoteEditorReady ? state.draft : null;
    _titleController = TextEditingController(text: draft?.title ?? '');
    _bodyController = TextEditingController(text: draft?.content ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null || !mounted) return;
    context.read<NoteEditorCubit>().mediaAdded(
      type: MediaType.image,
      localPath: picked.path,
    );
  }

  Future<void> _recordVoice() async {
    final result = await VoiceRecorderSheet.show(context);
    if (result == null || !mounted) return;
    context.read<NoteEditorCubit>().mediaAdded(
      type: MediaType.voice,
      localPath: result.path,
      durationMs: result.durationMs,
    );
  }

  void _addChecklistItem() {
    context.read<NoteEditorCubit>().todoAdded();
  }

  void _handleSave() {
    final editor = context.read<NoteEditorCubit>();
    editor.titleChanged(_titleController.text);
    editor.contentChanged(_bodyController.text);
    editor.save();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NoteEditorCubit, NoteEditorState>(
      listener: (context, state) {
        if (state is NoteEditorSaved) {
          context.read<NotesBloc>().add(const LoadNotes());
          context.router.pop();
        } else if (state is NoteEditorError) {
          context.showSnackbar(Text(state.message));
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.router.pop(),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: BlocBuilder<NoteEditorCubit, NoteEditorState>(
                buildWhen: (a, b) =>
                    (a is NoteEditorReady ? a.isSaving : false) !=
                    (b is NoteEditorReady ? b.isSaving : false),
                builder: (context, state) {
                  final saving = state is NoteEditorReady && state.isSaving;
                  return ElevatedButton(
                    onPressed: saving ? null : _handleSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E88E5),
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: saving
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Save',
                            style: TextStyle(color: Colors.white),
                          ),
                  );
                },
              ),
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EbTextFormField(
                  controller: _titleController,
                  style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w500),
                  decoration: const InputDecoration(
                    hintText: 'Title',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                  onChanged: (v) =>
                      context.read<NoteEditorCubit>().titleChanged(v),
                ),
                SizedBox(height: 8.h),
                const TagsSection(),
                SizedBox(height: 8.h),
                const MediaThumbnailRow(),
                SizedBox(height: 8.h),
                const TodoListEditor(),
                SizedBox(height: 8.h),
                EbTextFormField(
                  controller: _bodyController,
                  maxLines: null,
                  minLines: 6,
                  style: TextStyle(fontSize: 15.sp),
                  decoration: const InputDecoration(
                    hintText: 'Start typing...',
                    border: InputBorder.none,
                  ),
                  onChanged: (v) =>
                      context.read<NoteEditorCubit>().contentChanged(v),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.black12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ToolbarButton(
                  icon: Icons.image,
                  label: 'Image',
                  onTap: _pickImage,
                ),
                _ToolbarButton(
                  icon: Icons.mic,
                  label: 'Voice',
                  onTap: _recordVoice,
                ),
                _ToolbarButton(
                  icon: Icons.check_box,
                  label: 'Checklist',
                  onTap: _addChecklistItem,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ToolbarButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ToolbarButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 22),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}