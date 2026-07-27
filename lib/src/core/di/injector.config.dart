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
import '../../features/home/data/datasources/notes_remote_datasource.dart'
    as _i551;
import '../../features/home/data/repositories/notes_repository_impl.dart'
    as _i776;
import '../../features/home/domain/repositories/notes_repository.dart' as _i35;
import '../../features/home/domain/usecases/create_note_usecase.dart' as _i560;
import '../../features/home/domain/usecases/get_notes_usecase.dart' as _i355;
import '../../features/home/domain/usecases/modify_note_usecase.dart' as _i216;
import '../../features/home/domain/usecases/remove_note_usecase.dart' as _i89;
import '../../features/home/presentation/bloc/notes_bloc.dart' as _i737;
import '../../features/home/presentation/bloc/tags_bloc/tags_cubit.dart'
    as _i113;
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
    gh.factory<_i113.TagsCubit>(() => _i113.TagsCubit());
    gh.singleton<_i285.AppRouter>(() => _i285.AppRouter());
    gh.lazySingleton<_i454.SupabaseClient>(() => registerModule.supabaseClient);
    gh.lazySingleton<_i551.NoteRemoteDataSource>(
      () => _i551.NotesRemoteDataSourceImpl(
        supabaseClient: gh<_i454.SupabaseClient>(),
      ),
    );
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
    gh.lazySingleton<_i35.NotesRepository>(
      () => _i776.NotesRepositoryImpl(
        notesRemoteDataSource: gh<_i551.NoteRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i1065.SocialAuthRepository>(
      () => _i408.SocialAuthRepositoryImpl(
        socialLoginDatasource: gh<_i588.SocialLoginDatasource>(),
      ),
    );
    gh.singleton<_i387.SignInWithEmailUsecase>(
      () => _i387.SignInWithEmailUsecase(gh<_i787.AuthRepository>()),
    );
    gh.singleton<_i560.CreateNoteUsecase>(
      () => _i560.CreateNoteUsecase(gh<_i35.NotesRepository>()),
    );
    gh.singleton<_i355.GetNotesUsecase>(
      () => _i355.GetNotesUsecase(gh<_i35.NotesRepository>()),
    );
    gh.singleton<_i216.ModifyNoteUsecase>(
      () => _i216.ModifyNoteUsecase(gh<_i35.NotesRepository>()),
    );
    gh.singleton<_i89.RemoveNoteUsecase>(
      () => _i89.RemoveNoteUsecase(gh<_i35.NotesRepository>()),
    );
    gh.factory<_i384.SigninBloc>(
      () => _i384.SigninBloc(
        userSignIn: gh<_i387.SignInWithEmailUsecase>(),
        socialAuthRepository: gh<_i1065.SocialAuthRepository>(),
      ),
    );
    gh.factory<_i737.NotesBloc>(
      () => _i737.NotesBloc(
        getNotes: gh<_i355.GetNotesUsecase>(),
        createNote: gh<_i560.CreateNoteUsecase>(),
        modifyNote: gh<_i216.ModifyNoteUsecase>(),
        removeNote: gh<_i89.RemoveNoteUsecase>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i287.RegisterModule {}
