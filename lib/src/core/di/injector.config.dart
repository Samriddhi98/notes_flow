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
import '../../features/home/data/datasources/note_media_remote_datasource.dart'
    as _i809;
import '../../features/home/data/datasources/note_todos_remote_datasource.dart'
    as _i932;
import '../../features/home/data/datasources/notes_remote_datasource.dart'
    as _i551;
import '../../features/home/data/datasources/tags_remote_datasource.dart'
    as _i295;
import '../../features/home/data/repositories/note_media_repository_impl.dart'
    as _i448;
import '../../features/home/data/repositories/note_todos_repository_impl.dart'
    as _i979;
import '../../features/home/data/repositories/notes_repository_impl.dart'
    as _i776;
import '../../features/home/data/repositories/tags_repository_impl.dart'
    as _i189;
import '../../features/home/domain/repositories/note_media_repository.dart'
    as _i162;
import '../../features/home/domain/repositories/note_todos_repository.dart'
    as _i275;
import '../../features/home/domain/repositories/notes_repository.dart' as _i35;
import '../../features/home/domain/repositories/tags_repository.dart' as _i615;
import '../../features/home/domain/usecases/create_tag_usecase.dart' as _i199;
import '../../features/home/domain/usecases/delete_media_usecase.dart' as _i446;
import '../../features/home/domain/usecases/delete_note_usecase.dart' as _i799;
import '../../features/home/domain/usecases/delete_tag_usecase.dart' as _i99;
import '../../features/home/domain/usecases/get_notes_usecase.dart' as _i355;
import '../../features/home/domain/usecases/get_tags_usecase.dart' as _i610;
import '../../features/home/domain/usecases/save_note_usecase.dart' as _i223;
import '../../features/home/domain/usecases/toggle_pin_usecase.dart' as _i135;
import '../../features/home/domain/usecases/upload_media_usecase.dart' as _i789;
import '../../features/home/presentation/bloc/note_editor_cubit/note_editor_cubit.dart'
    as _i103;
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
    gh.lazySingleton<_i932.NoteTodosRemoteDataSource>(
      () => _i932.NoteTodosRemoteDataSourceImpl(
        supabaseClient: gh<_i454.SupabaseClient>(),
      ),
    );
    gh.lazySingleton<_i809.NoteMediaRemoteDataSource>(
      () => _i809.NoteMediaRemoteDataSourceImpl(
        supabaseClient: gh<_i454.SupabaseClient>(),
      ),
    );
    gh.lazySingleton<_i295.TagsRemoteDataSource>(
      () => _i295.TagsRemoteDataSourceImpl(
        supabaseClient: gh<_i454.SupabaseClient>(),
      ),
    );
    gh.lazySingleton<_i35.NotesRepository>(
      () => _i776.NotesRepositoryImpl(
        notesRemoteDataSource: gh<_i551.NoteRemoteDataSource>(),
        tagsDataSource: gh<_i295.TagsRemoteDataSource>(),
        todosDataSource: gh<_i932.NoteTodosRemoteDataSource>(),
        mediaDataSource: gh<_i809.NoteMediaRemoteDataSource>(),
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
    gh.lazySingleton<_i275.NoteTodosRepository>(
      () => _i979.NoteTodosRepositoryImpl(
        dataSource: gh<_i932.NoteTodosRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i615.TagsRepository>(
      () => _i189.TagsRepositoryImpl(
        dataSource: gh<_i295.TagsRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i162.NoteMediaRepository>(
      () => _i448.NoteMediaRepositoryImpl(
        dataSource: gh<_i809.NoteMediaRemoteDataSource>(),
      ),
    );
    gh.singleton<_i446.DeleteMediaUseCase>(
      () => _i446.DeleteMediaUseCase(gh<_i162.NoteMediaRepository>()),
    );
    gh.singleton<_i789.UploadMediaUseCase>(
      () => _i789.UploadMediaUseCase(gh<_i162.NoteMediaRepository>()),
    );
    gh.singleton<_i799.DeleteNoteUseCase>(
      () => _i799.DeleteNoteUseCase(gh<_i35.NotesRepository>()),
    );
    gh.singleton<_i355.GetNotesUseCase>(
      () => _i355.GetNotesUseCase(gh<_i35.NotesRepository>()),
    );
    gh.singleton<_i223.SaveNoteUseCase>(
      () => _i223.SaveNoteUseCase(gh<_i35.NotesRepository>()),
    );
    gh.singleton<_i135.TogglePinUseCase>(
      () => _i135.TogglePinUseCase(gh<_i35.NotesRepository>()),
    );
    gh.singleton<_i199.CreateTagUseCase>(
      () => _i199.CreateTagUseCase(gh<_i615.TagsRepository>()),
    );
    gh.singleton<_i99.DeleteTagUseCase>(
      () => _i99.DeleteTagUseCase(gh<_i615.TagsRepository>()),
    );
    gh.singleton<_i610.GetTagsUseCase>(
      () => _i610.GetTagsUseCase(gh<_i615.TagsRepository>()),
    );
    gh.factory<_i737.NotesBloc>(
      () => _i737.NotesBloc(
        gh<_i355.GetNotesUseCase>(),
        gh<_i799.DeleteNoteUseCase>(),
        gh<_i135.TogglePinUseCase>(),
      ),
    );
    gh.factory<_i113.TagsCubit>(
      () => _i113.TagsCubit(
        gh<_i610.GetTagsUseCase>(),
        gh<_i199.CreateTagUseCase>(),
        gh<_i99.DeleteTagUseCase>(),
      ),
    );
    gh.factory<_i384.SigninBloc>(
      () => _i384.SigninBloc(
        userSignIn: gh<_i387.SignInWithEmailUsecase>(),
        socialAuthRepository: gh<_i1065.SocialAuthRepository>(),
      ),
    );
    gh.factory<_i103.NoteEditorCubit>(
      () => _i103.NoteEditorCubit(
        gh<_i223.SaveNoteUseCase>(),
        gh<_i789.UploadMediaUseCase>(),
        gh<_i446.DeleteMediaUseCase>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i287.RegisterModule {}
