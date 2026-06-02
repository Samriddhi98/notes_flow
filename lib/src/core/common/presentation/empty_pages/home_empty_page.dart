import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_flow/src/core/di/injector.dart';
import 'package:notes_flow/src/features/home/presentation/bloc/notes_bloc.dart';
import 'package:notes_flow/src/features/home/presentation/bloc/tags_bloc/tags_cubit.dart';

@RoutePage()
class HomeEmptyPage extends StatelessWidget {
  const HomeEmptyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NotesBloc>(
          create: (_) => getIt<NotesBloc>()..add(const LoadNotes()),
        ),
        BlocProvider<TagsCubit>(
          create: (_) => getIt<TagsCubit>()..loadTags(),
        ),
      ],
      child: const AutoRouter(),
    );
  }
}
