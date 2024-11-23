import 'package:get_it/get_it.dart';
import 'package:time_tracking_to_do/data/data_sources/remote/todoist_api_service.dart';
import 'package:time_tracking_to_do/data/repositories/comment_repository_impl.dart';
import 'package:time_tracking_to_do/data/repositories/task_repository_impl.dart';
import 'package:time_tracking_to_do/domain/repositories/comment_repository.dart';
import 'package:time_tracking_to_do/domain/repositories/task_repository.dart';
import 'package:time_tracking_to_do/domain/use_cases/comment_use_cases.dart';
import 'package:time_tracking_to_do/domain/use_cases/task_use_cases.dart';
import 'package:time_tracking_to_do/presentation/board_detail/bloc/task_bloc.dart';
import 'package:time_tracking_to_do/presentation/comment/bloc/comment_bloc.dart';


final sl = GetIt.instance;

void setupDependencyInjection() {
  /// Register ApiService
  sl.registerLazySingleton<ApiService>(() => ApiService());

  /// Data Layer
  sl.registerLazySingleton<TaskRepository>(
      () => TaskRepositoryImpl(apiService: sl()));
  /// Register CommentRepo and its implementation
  sl.registerLazySingleton<CommentRepo>(() => CommentRepoImpl(apiService: sl()));

  /// Register Use Cases
  sl.registerLazySingleton<FetchCommentsUseCase>(() => FetchCommentsUseCase(sl<CommentRepo>()));
  sl.registerLazySingleton<SendCommentUseCase>(() => SendCommentUseCase(sl<CommentRepo>()));
  /// Use Cases
  sl.registerLazySingleton(() => GetTasksUseCase(sl()));
  sl.registerLazySingleton(() => AddTaskUseCase(sl()));
  sl.registerLazySingleton(() => UpdateTaskUseCase(sl()));
  sl.registerLazySingleton(() => MoveTaskUseCase(sl()));
  sl.registerLazySingleton(() => DeleteTaskUseCase(sl()));

  /// BLoC
  sl.registerFactory(() => TaskBloc(
        getTasksUseCase: sl(),
        addTaskUseCase: sl(),
        updateTaskUseCase: sl(),
        moveTaskUseCase: sl(),
        deleteTaskUseCase: sl(),
      ));

  /// Register Bloc
  sl.registerFactory<CommentBloc>(() => CommentBloc(
    fetchCommentsUseCase: sl<FetchCommentsUseCase>(),
    sendCommentUseCase: sl<SendCommentUseCase>(),
  ));
}
