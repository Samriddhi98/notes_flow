import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_flow/src/core/di/injector.dart';
import 'package:notes_flow/src/features/home/presentation/bloc/notes_bloc.dart';

@RoutePage()
class HomeEmptyPage extends StatelessWidget {
  const HomeEmptyPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Provided on the shell so the list and the editor share one bloc — saving
    // in the editor refreshes the list behind it.
    return BlocProvider(
      create: (context) => getIt<NotesBloc>()..add(const GetAllNotes()),
      child: AutoRouter(),
    );
  }
}
