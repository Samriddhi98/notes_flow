import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../domain/entities/tag_entity.dart';
import '../bloc/notes_bloc.dart';
import '../bloc/tags_bloc/tags_cubit.dart';

class TagFilterBar extends StatelessWidget {
  const TagFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TagsCubit, List<TagEntity>>(
      builder: (context, tags) {
        return BlocBuilder<NotesBloc, NotesState>(
          buildWhen: (a, b) =>
              a is! NotesLoaded ||
              b is! NotesLoaded ||
              a.activeTagId != b.activeTagId,
          builder: (context, state) {
            final activeTagId = state is NotesLoaded ? state.activeTagId : null;
            return SizedBox(
              height: 40.h,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _Chip(
                    label: 'All',
                    selected: activeTagId == null,
                    onTap: () =>
                        context.read<NotesBloc>().add(const FilterByTag(null)),
                  ),
                  for (final tag in tags) ...[
                    SizedBox(width: 6.w),
                    _Chip(
                      label: tag.name,
                      selected: activeTagId == tag.id,
                      onTap: () =>
                          context.read<NotesBloc>().add(FilterByTag(tag.id)),
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _Chip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: selected ? Colors.blue : Colors.blue[50],
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.blue[800],
            fontWeight: FontWeight.w500,
            fontSize: 12.sp,
          ),
        ),
      ),
    );
  }
}
