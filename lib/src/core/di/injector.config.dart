// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:supabase_flutter/supabase_flutter.dart' as _i454;

import '../../features/auth/data/datasources/auth_remote_datasource.dart'
    as _i161;
import '../../features/auth/data/datasources/social_login_datasource.dart'
    as _i588;
import '../../features/auth/data/respositories/auth_repository_impl.dart'
    as _i561;
import '../../features/auth/data/respositories/social_login_repository_impl.dart'
    as _i408;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/domain/repositories/social_login_repository.dart'
    as _i1065;
import '../../features/auth/domain/usecases/user_signin_usecase.dart' as _i387;
import '../../features/auth/presentation/bloc/signIn/signin_bloc.dart' as _i384;
import '../router/router.dart' as _i285;
import 'injector_modules.dart' as _i287;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.singleton<_i285.AppRouter>(() => _i285.AppRouter());
    gh.lazySingleton<_i454.SupabaseClient>(() => registerModule.supabaseClient);
    gh.lazySingleton<_i161.AuthRemoteDataSource>(
      () => _i161.AuthRemoteDataSourceImpl(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i588.SocialLoginDatasource>(
      () => _i588.SocialLoginDataSourceImpl(
        supabaseClient: gh<_i454.SupabaseClient>(),
      ),
    );
    gh.lazySingleton<_i787.AuthRepository>(
      () => _i561.AuthRepositoryImpl(gh<_i161.AuthRemoteDataSource>()),
    );
    gh.lazySingleton<_i1065.SocialAuthRepository>(
      () => _i408.SocialAuthRepositoryImpl(
        socialLoginDatasource: gh<_i588.SocialLoginDatasource>(),
      ),
    );
    gh.singleton<_i387.SignInWithEmailUsecase>(
      () => _i387.SignInWithEmailUsecase(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i384.SigninBloc>(
      () => _i384.SigninBloc(
        userSignIn: gh<_i387.SignInWithEmailUsecase>(),
        socialAuthRepository: gh<_i1065.SocialAuthRepository>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i287.RegisterModule {}
