// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i8;
import 'package:notes_flow/src/core/common/presentation/empty_pages/home_empty_page.dart'
    as _i1;
import 'package:notes_flow/src/core/common/presentation/empty_pages/onboard_empty_page.dart'
    as _i4;
import 'package:notes_flow/src/features/auth/presentation/screens/sign_in_screen.dart'
    as _i5;
import 'package:notes_flow/src/features/auth/presentation/screens/sign_up_screen.dart'
    as _i6;
import 'package:notes_flow/src/features/home/presentation/screens/notes_editor_screen.dart'
    as _i2;
import 'package:notes_flow/src/features/home/presentation/screens/notes_list_screen.dart'
    as _i3;
import 'package:notes_flow/src/features/splash_screen.dart' as _i7;

/// generated route for
/// [_i1.HomeEmptyPage]
class HomeEmptyRoute extends _i8.PageRouteInfo<void> {
  const HomeEmptyRoute({List<_i8.PageRouteInfo>? children})
    : super(HomeEmptyRoute.name, initialChildren: children);

  static const String name = 'HomeEmptyRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i1.HomeEmptyPage();
    },
  );
}

/// generated route for
/// [_i2.NoteEditorScreen]
class NoteEditorRoute extends _i8.PageRouteInfo<void> {
  const NoteEditorRoute({List<_i8.PageRouteInfo>? children})
    : super(NoteEditorRoute.name, initialChildren: children);

  static const String name = 'NoteEditorRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i2.NoteEditorScreen();
    },
  );
}

/// generated route for
/// [_i3.NotesListScreen]
class NotesListRoute extends _i8.PageRouteInfo<void> {
  const NotesListRoute({List<_i8.PageRouteInfo>? children})
    : super(NotesListRoute.name, initialChildren: children);

  static const String name = 'NotesListRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i3.NotesListScreen();
    },
  );
}

/// generated route for
/// [_i4.OnboardEmptyPage]
class OnboardEmptyRoute extends _i8.PageRouteInfo<void> {
  const OnboardEmptyRoute({List<_i8.PageRouteInfo>? children})
    : super(OnboardEmptyRoute.name, initialChildren: children);

  static const String name = 'OnboardEmptyRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i4.OnboardEmptyPage();
    },
  );
}

/// generated route for
/// [_i5.SignInScreen]
class SignInRoute extends _i8.PageRouteInfo<void> {
  const SignInRoute({List<_i8.PageRouteInfo>? children})
    : super(SignInRoute.name, initialChildren: children);

  static const String name = 'SignInRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i5.SignInScreen();
    },
  );
}

/// generated route for
/// [_i6.SignUpScreen]
class SignUpRoute extends _i8.PageRouteInfo<void> {
  const SignUpRoute({List<_i8.PageRouteInfo>? children})
    : super(SignUpRoute.name, initialChildren: children);

  static const String name = 'SignUpRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i6.SignUpScreen();
    },
  );
}

/// generated route for
/// [_i7.SplashScreen]
class SplashRoute extends _i8.PageRouteInfo<void> {
  const SplashRoute({List<_i8.PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i7.SplashScreen();
    },
  );
}
