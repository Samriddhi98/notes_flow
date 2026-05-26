import 'package:flutter/material.dart';
import 'package:notes_flow/src/core/config/env.dart';
import 'package:notes_flow/src/core/di/injector.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'src/app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: Env.supabaseUrl,
    anonKey: Env.supabaseAnonKey,
  );
  await configureInjector();

  runApp(MyApp());
}
