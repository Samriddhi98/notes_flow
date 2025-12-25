import 'package:flutter/material.dart';
import 'package:notes_flow/src/core/di/injector.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'src/app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://vmngzxdrdqjsttlpsohn.supabase.co',
    anonKey: 'sb_secret_6cY2KP25mFnxe7KwoL-oCQ_LsjldFhS',
  );
  await configureInjector();

  runApp(MyApp());
}
