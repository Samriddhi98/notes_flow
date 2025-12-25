import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:notes_flow/src/core/router/router.gr.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Session? session;

  @override
  void initState() {
    super.initState();
    session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      context.router.replace(HomeEmptyRoute());
    } else {
      context.router.replace(OnboardEmptyRoute());
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('SPLASHH')));
  }
}
