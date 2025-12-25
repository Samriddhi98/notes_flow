import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notes_flow/src/core/extensions/build_context.dart';
import 'package:notes_flow/src/core/router/router.gr.dart';

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
            Expanded(child: Center(child: Text('Notes page'))),
          ],
        ),
      ),
    );
  }
}
