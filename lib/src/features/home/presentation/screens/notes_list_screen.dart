import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notes_flow/src/core/extensions/build_context.dart';
import 'package:notes_flow/src/core/router/router.gr.dart';
import 'package:notes_flow/src/features/home/domain/entities/notes_entity.dart';
import 'package:notes_flow/src/features/home/presentation/bloc/notes_bloc.dart';

@RoutePage()
class NotesListScreen extends StatefulWidget {
  const NotesListScreen({super.key});

  @override
  State<NotesListScreen> createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: GestureDetector(
        onTap: () {
          context.router.push(NoteEditorRoute());
        },
        child: Material(
          elevation: 4.0,
          borderRadius: BorderRadius.circular(16.0),
          color: Colors.blue,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 12.0,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min, // Essential for FAB size
              children: const [
                Icon(Icons.note_add_outlined, color: Colors.white),
                SizedBox(width: 8.0),
                Text(
                  'Add Note',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        width: 1.sw,
        height: 1.sh,
        padding: EdgeInsets.only(top: 48.h, left: 24.w, right: 24.w),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.l10n.myNotes,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CircleAvatar(radius: 24.sp),
              ],
            ),
            Expanded(
              child: BlocBuilder<NotesBloc, NotesState>(
                // Ignore the editor's saving states so the list keeps its
                // contents on screen while a save is in flight.
                buildWhen: (previous, current) =>
                    current is NotesLoading ||
                    current is NotesLoaded ||
                    current is NotesFailure,
                builder: (context, state) {
                  switch (state) {
                    case NotesLoaded(:final notes):
                      return _NotesList(notes: notes);
                    case NotesFailure(:final failureMsg):
                      return _ErrorView(message: failureMsg);
                    default:
                      return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotesList extends StatelessWidget {
  final List<NotesEntity> notes;

  const _NotesList({required this.notes});

  @override
  Widget build(BuildContext context) {
    Future<void> refresh() async {
      context.read<NotesBloc>().add(const GetAllNotes());
    }

    if (notes.isEmpty) {
      return RefreshIndicator(
        onRefresh: refresh,
        child: ListView(
          children: [
            SizedBox(height: 120.h),
            Center(
              child: Text(
                'No notes yet.\nTap "Add Note" to write your first one.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14.sp, color: Colors.black54),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: refresh,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        itemCount: notes.length,
        separatorBuilder: (context, index) => SizedBox(height: 12.h),
        itemBuilder: (context, index) {
          final note = notes[index];
          return _NoteCard(note: note);
        },
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  final NotesEntity note;

  const _NoteCard({required this.note});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(note.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) =>
          context.read<NotesBloc>().add(RemoveNote(note.id)),
      child: InkWell(
        onTap: () => context.router.push(NoteEditorRoute(note: note)),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      note.title.isEmpty ? 'Untitled' : note.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () =>
                        context.read<NotesBloc>().add(TogglePinned(note)),
                    child: Icon(
                      note.isPinned
                          ? Icons.push_pin
                          : Icons.push_pin_outlined,
                      size: 18.sp,
                      color: note.isPinned ? Colors.blue[800] : Colors.black45,
                    ),
                  ),
                ],
              ),
              if (note.content.isNotEmpty) ...[
                SizedBox(height: 6.h),
                Text(
                  note.content,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13.sp, color: Colors.black87),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;

  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.sp, color: Colors.black54),
          ),
          SizedBox(height: 12.h),
          ElevatedButton(
            onPressed: () =>
                context.read<NotesBloc>().add(const GetAllNotes()),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
