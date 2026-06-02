import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../bloc/note_editor_cubit/note_editor_cubit.dart';

class TodoListEditor extends StatelessWidget {
  const TodoListEditor({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteEditorCubit, NoteEditorState>(
      buildWhen: (a, b) {
        if (a is! NoteEditorReady || b is! NoteEditorReady) return true;
        return a.draft.todos != b.draft.todos;
      },
      builder: (context, state) {
        if (state is! NoteEditorReady) return const SizedBox.shrink();
        final todos = state.draft.todos;
        if (todos.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final todo in todos)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                child: Row(
                  children: [
                    SizedBox(
                      width: 28.w,
                      height: 28.w,
                      child: Checkbox(
                        value: todo.isDone,
                        onChanged: (_) =>
                            context.read<NoteEditorCubit>().todoToggled(todo.id),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: TextFormField(
                        initialValue: todo.text,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: todo.isDone ? Colors.black45 : Colors.black87,
                          decoration: todo.isDone
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'List item',
                          border: InputBorder.none,
                          isDense: true,
                        ),
                        onChanged: (v) =>
                            context.read<NoteEditorCubit>().todoTextChanged(todo.id, v),
                      ),
                    ),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: Icon(Icons.close, size: 18.sp, color: Colors.black38),
                      onPressed: () =>
                          context.read<NoteEditorCubit>().todoRemoved(todo.id),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
