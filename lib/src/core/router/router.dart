import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';
import 'package:notes_flow/src/core/router/router.gr.dart';

@singleton
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    CustomRoute(
      initial: true,
      page: SplashRoute.page,
      transitionsBuilder: TransitionsBuilders.slideBottom,
    ),
    AutoRoute(
      page: OnboardEmptyRoute.page,
      children: [
        AutoRoute(page: SignInRoute.page, initial: true),
        AutoRoute(page: SignUpRoute.page),
      ],
    ),
    AutoRoute(
      page: HomeEmptyRoute.page,
      children: [
        AutoRoute(page: NotesListRoute.page, initial: true),
        AutoRoute(page: NoteEditorRoute.page),
      ],
    ),

    /// routes go here
  ];
}
