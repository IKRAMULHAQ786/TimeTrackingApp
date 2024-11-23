// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:time_tracking_to_do/core/utils/helpers.dart';
// import 'package:time_tracking_to_do/data/models/status_enum.dart';
// import 'package:time_tracking_to_do/data/models/task_model.dart';
// import 'package:time_tracking_to_do/presentation/screens/kanban_board_screen/bloc/task_bloc.dart';
// import 'package:time_tracking_to_do/presentation/widgets/task_comments.dart';
//
// class TaskDetailScreen extends StatelessWidget {
//   final TaskModel task;
//
//   const TaskDetailScreen({super.key, required this.task});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: const Text('Task Details'),
//         actions: [
//           IconButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               icon: const Icon(Icons.close))
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               task.content ?? '',
//               style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             PopupMenuButton<TaskStatus>(
//               onSelected: (status) {
//                 context.read<TaskBloc>().add(
//                       MoveTaskEvent(task.id ?? '', status.name),
//                     );
//               },
//               itemBuilder: (context) {
//                 return TaskStatus.values
//                     .where((status) => status != task.labels?.first)
//                     .map((status) {
//                   return PopupMenuItem<TaskStatus>(
//                     value: status,
//                     child: Text(status.name.capitalize()),
//                   );
//                 }).toList();
//               },
//               icon: Row(
//                 children: [
//                   Text('in list ${task.status}'),
//                   const Icon(Icons.keyboard_arrow_down),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 8),
//             const Text(
//               'Description:',
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             Text(task.description ?? ''),
//             const SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Status: ${task.status}'),
//                 Text('Duration: ${task.duration!.amount!}'),
//               ],
//             ),
//             const SizedBox(height: 16),
//             Text('Created: ${task.createdAt}'),
//             TaskComments(
//               taskId: task.id!,
//             ),
//             const SizedBox(height: 16),
//           ],
//         ),
//       ),
//     );
//   }
// }
