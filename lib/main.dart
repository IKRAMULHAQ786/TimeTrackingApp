import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_tracking_to_do/core/dependency_injection.dart';
import 'package:time_tracking_to_do/presentation/board_detail/bloc/task_bloc.dart';
import 'package:time_tracking_to_do/presentation/board_detail/kanban_board_screen.dart';
import 'package:time_tracking_to_do/presentation/comment/bloc/comment_bloc.dart';

void main() {
  runZonedGuarded(
    () {
      /// Ensure widgets binding is initialized
      WidgetsFlutterBinding.ensureInitialized();

      /// Setup Dependency Injection
      setupDependencyInjection();

      runApp(const MainApp());
    },
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TaskBloc>(
          create: (_) => sl<TaskBloc>()..add(LoadTasksEvent()),
        ),
        BlocProvider<CommentBloc>(
          create: (_) => sl<CommentBloc>(),
        ),
      ],
      child: const ScreenUtilInit(
          child: MaterialApp(
        home: KanbanBoardScreen(),
      )),
    );
  }
}
