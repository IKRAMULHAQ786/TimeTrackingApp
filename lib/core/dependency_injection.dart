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

  /// Register Data Layer Repositories
  ///
  /// Register TaskRepo
  sl.registerLazySingleton<TaskRepository>(() => TaskRepositoryImpl(apiService: sl<ApiService>()));
  /// Register CommentRepo
  sl.registerLazySingleton<CommentRepo>(() => CommentRepoImpl(apiService: sl<ApiService>()));

  /// Register Use Cases
  ///
  /// Comment User Cases
  sl.registerLazySingleton<FetchCommentsUseCase>(() => FetchCommentsUseCase(sl<CommentRepo>()));
  sl.registerLazySingleton<SendCommentUseCase>(() => SendCommentUseCase(sl<CommentRepo>()));
  /// Task Use Cases
  sl.registerLazySingleton<GetTasksUseCase>(() => GetTasksUseCase(sl()));
  sl.registerLazySingleton<AddTaskUseCase>(() => AddTaskUseCase(sl()));
  sl.registerLazySingleton<UpdateTaskUseCase>(() => UpdateTaskUseCase(sl()));
  sl.registerLazySingleton<MoveTaskUseCase>(() => MoveTaskUseCase(sl()));
  sl.registerLazySingleton<DeleteTaskUseCase>(() => DeleteTaskUseCase(sl()));

  /// Register Bloc
  ///
  ///TaskBloc
  sl.registerFactory<TaskBloc>(() => TaskBloc(
        getTasksUseCase: sl<GetTasksUseCase>(),
        addTaskUseCase: sl<AddTaskUseCase>(),
        updateTaskUseCase: sl<UpdateTaskUseCase>(),
        moveTaskUseCase: sl<MoveTaskUseCase>(),
        deleteTaskUseCase: sl<DeleteTaskUseCase>(),
      ));
  ///CommentBloc
  sl.registerFactory<CommentBloc>(() => CommentBloc(
    fetchCommentsUseCase: sl<FetchCommentsUseCase>(),
    sendCommentUseCase: sl<SendCommentUseCase>(),
  ));
}
