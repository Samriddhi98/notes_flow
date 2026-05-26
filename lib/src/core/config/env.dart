import 'package:envied/envied.dart';

part 'env.g.dart';

/// Supabase configuration loaded from the gitignored `.env` file at build time
/// via `envied`. Copy `.env.example` to `.env` and fill in the values, then run
/// `build_runner build` to (re)generate `env.g.dart`.
@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'SUPABASE_URL')
  static const String supabaseUrl = _Env.supabaseUrl;

  @EnviedField(varName: 'SUPABASE_ANON_KEY')
  static const String supabaseAnonKey = _Env.supabaseAnonKey;
}