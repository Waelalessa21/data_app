// import 'package:data_app/pages/chat/ui/widgets/chat_bubble.dart';
// import 'package:data_app/pages/chat/ui/widgets/chat_header.dart';
// import 'package:data_app/pages/chat/ui/widgets/chat_input.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';

// class Chat extends StatelessWidget {
//   const Chat({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           const ChatHeader(),
//           const SizedBox(height: 16),
//           Expanded(
//             child:
//                 Container(
//                       decoration: BoxDecoration(
//                         color: Colors.black,
//                         borderRadius: BorderRadius.circular(18),
//                         border: Border.all(
//                           color: Colors.white.withOpacity(0.1),
//                           width: 1,
//                         ),
//                       ),
//                       padding: const EdgeInsets.all(16),
//                       child: Column(
//                         children: [
//                           Expanded(
//                             child: ListView.builder(
//                               controller: _scrollController,
//                               itemCount: _messages.length,
//                               itemBuilder: (context, index) {
//                                 final message = _messages[index];
//                                 return ChatBubble(
//                                   message: message,
//                                   index: index,
//                                 );
//                               },
//                             ),
//                           ),
//                           const SizedBox(height: 12),
//                           ChatInput(
//                             controller: _controller,
//                             onSubmitted: (_) => _handleSubmit(),
//                             onSendPressed: _handleSubmit,
//                           ),
//                         ],
//                       ),
//                     )
//                     .animate()
//                     .fadeIn(duration: 500.ms, delay: 200.ms)
//                     .scale(
//                       begin: const Offset(0.95, 0.95),
//                       end: const Offset(1, 1),
//                       duration: 500.ms,
//                       delay: 200.ms,
//                     ),
//           ),
//         ],
//       ),
//     );
//   }
// }
