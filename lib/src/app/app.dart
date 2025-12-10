import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notes_flow/l10n/app_localizations.dart';
import 'package:notes_flow/src/features/auth/presentation/sign_in_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      // Use builder only if you need to use library outside ScreenUtilInit context
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Notes Flow',
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          // You can use the library anywhere in the app even in theme
          theme: ThemeData(
            fontFamily: 'Inter',
            colorScheme: .fromSeed(seedColor: Colors.deepPurple),
          ),
          home: SignInScreen(),
        );
      },
    );
  }
}
