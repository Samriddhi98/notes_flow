import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notes_flow/src/core/extensions/build_context.dart';
import 'package:notes_flow/src/core/router/router.gr.dart';

import '../bloc/notes_bloc.dart';
import '../widgets/note_card.dart';
import '../widgets/tag_filter_bar.dart';

@RoutePage()
class NotesListScreen extends StatelessWidget {
  const NotesListScreen({super.key});

  void _openEditor(BuildContext context, {String? noteId}) {
    context.router.push(NoteEditorRoute(noteId: noteId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: GestureDetector(
        onTap: () => _openEditor(context),
        child: Material(
          elevation: 4.0,
          borderRadius: BorderRadius.circular(16.0),
          color: Colors.blue,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.note_add_outlined, color: Colors.white),
                SizedBox(width: 8.0),
                Text(
                  'Add Note',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.l10n.myNotes,
                      style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
                    ),
                    CircleAvatar(radius: 20.sp),
                  ],
                ),
              ),
              SizedBox(height: 8.h),
              const TagFilterBar(),
              SizedBox(height: 12.h),
              Expanded(
                child: BlocBuilder<NotesBloc, NotesState>(
                  builder: (context, state) {
                    return switch (state) {
                      NotesInitial() || NotesLoading() =>
                        const Center(child: CircularProgressIndicator()),
                      NotesError(message: final msg) => Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Text(msg, textAlign: TextAlign.center),
                        ),
                      ),
                      NotesLoaded() => _buildList(context, state),
                    };
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, NotesLoaded state) {
    final notes = [...state.visibleNotes]..sort((a, b) {
        if (a.isPinned != b.isPinned) return a.isPinned ? -1 : 1;
        return b.updatedAt.compareTo(a.updatedAt);
      });
    if (notes.isEmpty) {
      return Center(
        child: Text(
          state.activeTagId == null
              ? 'No notes yet. Tap Add Note to create one.'
              : 'No notes with this tag.',
          style: TextStyle(color: Colors.black54, fontSize: 14.sp),
        ),
      );
    }
    return ListView.separated(
      itemCount: notes.length,
      separatorBuilder: (context, index) => SizedBox(height: 10.h),
      itemBuilder: (context, i) {
        final note = notes[i];
        return Dismissible(
          key: ValueKey(note.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (_) =>
              context.read<NotesBloc>().add(DeleteNote(note.id)),
          child: NoteCard(
            note: note,
            onTap: () => _openEditor(context, noteId: note.id),
            onPinToggle: () =>
                context.read<NotesBloc>().add(TogglePin(note.id)),
          ),
        );
      },
    );
  }
}