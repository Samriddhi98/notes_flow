import 'package:flutter/material.dart';
import 'package:notes_flow/src/core/di/injector.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'src/app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://czjqltomdjeflpbzfuvf.supabase.co',
    anonKey: 'sb_publishable_zDI-UocAmwLyDV3J0FUfGg_EssX84Tx',
  );
  await configureInjector();

  runApp(MyApp());
}
