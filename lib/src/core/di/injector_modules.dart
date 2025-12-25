import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@module
abstract class RegisterModule {
  // Use @lazySingleton for external libraries you don't own.
  @lazySingleton
  SupabaseClient get supabaseClient => Supabase.instance.client;
}
