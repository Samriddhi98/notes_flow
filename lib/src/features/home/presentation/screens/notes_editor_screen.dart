import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notes_flow/src/core/di/injector.dart';
import 'package:notes_flow/src/core/extensions/build_context.dart';
import 'package:notes_flow/src/core/widgets/custom_text_field.dart';
import 'package:notes_flow/src/features/home/domain/entities/notes_entity.dart';
import 'package:notes_flow/src/features/home/presentation/bloc/notes_bloc.dart';
import 'package:notes_flow/src/features/home/presentation/bloc/tags_bloc/tags_cubit.dart';
import 'package:notes_flow/src/features/home/presentation/widgets/tags_section.dart';

@RoutePage()
class NoteEditorScreen extends StatefulWidget {
  /// The note being edited, or null when composing a new one.
  final NotesEntity? note;

  const NoteEditorScreen({super.key, this.note});

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  late final TextEditingController titleController;
  late final TextEditingController bodyController;
  late bool isPinned;

  bool get _isEditing => widget.note != null;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.note?.title ?? '');
    bodyController = TextEditingController(text: widget.note?.content ?? '');
    isPinned = widget.note?.isPinned ?? false;
  }

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    super.dispose();
  }

  void _save() {
    final title = titleController.text.trim();
    final content = bodyController.text.trim();

    if (title.isEmpty && content.isEmpty) {
      context.showSnackbar(const Text("Nothing to save yet"));
      return;
    }

    final notesBloc = context.read<NotesBloc>();
    if (_isEditing) {
      notesBloc.add(
        UpdateNote(
          note: widget.note!,
          title: title,
          content: content,
          isPinned: isPinned,
        ),
      );
    } else {
      notesBloc.add(
        AddNotes(title: title, content: content, isPinned: isPinned),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<TagsCubit>(),
      child: BlocListener<NotesBloc, NotesState>(
        listener: (context, state) {
          switch (state) {
            case NoteSaved():
              context.router.pop();
            case NoteSaveFailure(:final failureMsg):
              context.showSnackbar(Text(failureMsg));
            default:
              break;
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
              IconButton(
                tooltip: isPinned ? "Unpin" : "Pin",
                icon: Icon(
                  isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                  color: isPinned ? const Color(0xFF1E88E5) : Colors.black54,
                ),
                onPressed: () => setState(() => isPinned = !isPinned),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: BlocBuilder<NotesBloc, NotesState>(
                  builder: (context, state) {
                    final isSaving = state is NoteSaving;
                    return ElevatedButton(
                      onPressed: isSaving ? null : _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E88E5),
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: isSaving
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              "Save",
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title TextField
                EbTextFormField(
                  controller: titleController,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: const InputDecoration(
                    hintText: "Title",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                ),

                const SizedBox(height: 8),

                // Tags Row
                TagsSection(),

                const SizedBox(height: 8),

                // Body TextField
                Expanded(
                  child: TextField(
                    controller: bodyController,
                    maxLines: null,
                    expands: true,
                    decoration: const InputDecoration(
                      hintText: "Start typing...",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Toolbar
          bottomNavigationBar: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.black12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _bottomButton(icon: Icons.image, label: "Image"),
                _bottomButton(icon: Icons.mic, label: "Voice"),
                _bottomButton(icon: Icons.check_box, label: "Checklist"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomButton({required IconData icon, required String label}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 22),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
