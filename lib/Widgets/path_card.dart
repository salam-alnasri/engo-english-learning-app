// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:timelines_plus/timelines_plus.dart';
// // import 'package:engo/services/progress_service.dart';

// class PathCard extends StatelessWidget {
//   const PathCard({super.key, required this.levels});

//   final List<Map<String, dynamic>> levels;

//   @override
//   Widget build(BuildContext context) {
//     return Timeline.tileBuilder(
//       theme: TimelineThemeData(
//         indicatorPosition: 0.5,
//         nodePosition: 0.1,

//         connectorTheme: const ConnectorThemeData(thickness: 6.0),
//       ),
//       builder: TimelineTileBuilder.connected(
//         connectionDirection: ConnectionDirection.before,
//         itemCount: levels.length,
//         contentsBuilder: (context, index) {
//           final level = levels[index];
//           return Padding(
//             padding: const EdgeInsets.symmetric(vertical: 20),
//             child: GestureDetector(
//               onTap: () {
//                 if (level['screen'] != null) {
//                   Get.to(level['screen']);
//                 }
//               },
//               child: Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.blue,
//                   borderRadius: BorderRadius.circular(10),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black54,
//                       blurRadius: 2,
//                       offset: const Offset(2, 2),
//                     ),
//                   ],
//                 ),
//                 margin: EdgeInsets.only(
//                   left: index.isEven ? 0 : 50,
//                   right: index.isEven ? 50 : 0,
//                 ),
//                 child: Column(
//                   crossAxisAlignment: index.isEven
//                       ? CrossAxisAlignment.start
//                       : CrossAxisAlignment.end,
//                   children: [
//                     Text(
//                       level['title'] ?? '',
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 18,
//                         color: Colors.white,
//                       ),
//                     ),
//                     const SizedBox(height: 5),
//                     Text(
//                       level['description'] ?? '',
//                       style: const TextStyle(fontSize: 14, color: Colors.white),
//                       textAlign: index.isEven ? TextAlign.start : TextAlign.end,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//         indicatorBuilder: (context, index) {
//           final level = levels[index];
//           return Container(
//             height: 60,
//             width: 60,
//             margin: const EdgeInsets.symmetric(horizontal: 20),
//             decoration: BoxDecoration(
//               color: Colors.blue,
//               shape: BoxShape.circle,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black54,
//                   blurRadius: 2,
//                   offset: const Offset(1, 1),
//                 ),
//               ],
//             ),
//             child: Center(
//               child: Icon(level['icon'], color: Colors.white, size: 35),
//             ),
//           );
//         },
//         connectorBuilder: (context, index, type) {
//           return const SolidLineConnector(color: Colors.grey);
//         },
//       ),
//     );
//   }
// }
