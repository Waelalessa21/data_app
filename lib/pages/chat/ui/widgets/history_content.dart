// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:iconsax/iconsax.dart';

// class HistoryContent extends StatelessWidget {
//   const HistoryContent({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                     'Previous chats',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   )
//                   .animate()
//                   .fadeIn(duration: 400.ms, delay: 100.ms)
//                   .slideX(begin: 0.2, end: 0, duration: 500.ms, delay: 100.ms),
//               const SizedBox(height: 4),
//               const Text(
//                     'Quick access to your queries',
//                     style: TextStyle(color: Colors.white54, fontSize: 11),
//                   )
//                   .animate()
//                   .fadeIn(duration: 400.ms, delay: 200.ms)
//                   .slideX(begin: 0.2, end: 0, duration: 500.ms, delay: 200.ms),
//             ],
//           ),
//         ),
//         Divider(height: 1, color: Colors.white.withOpacity(0.1)),
//         Expanded(
//           child: ListView.builder(
//             itemCount: _previousChats.length,
//             itemBuilder: (context, index) {
//               final title = _previousChats[index];
//               return InkWell(
//                     onTap: () {},
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 10,
//                       ),
//                       child: Row(
//                         children: [
//                           Icon(
//                             Iconsax.message,
//                             size: 16,
//                             color: Colors.white.withOpacity(0.5),
//                           ),
//                           const SizedBox(width: 8),
//                           Expanded(
//                             child: Text(
//                               title,
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                               style: TextStyle(
//                                 color: Colors.white.withOpacity(0.7),
//                                 fontSize: 12,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   )
//                   .animate(key: ValueKey(title))
//                   .fadeIn(duration: 300.ms, delay: (index * 50).ms)
//                   .slideX(
//                     begin: 0.2,
//                     end: 0,
//                     duration: 400.ms,
//                     delay: (index * 50).ms,
//                   );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
