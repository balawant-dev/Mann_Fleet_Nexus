// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
//
// class LoopVideoScreen extends StatefulWidget {
//   const LoopVideoScreen({super.key});
//
//   @override
//   State<LoopVideoScreen> createState() => _LoopVideoScreenState();
// }
//
// class _LoopVideoScreenState extends State<LoopVideoScreen> {
//   late VideoPlayerController _controller;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _controller = VideoPlayerController.asset('assets/images/video.mp4')
//       ..initialize().then((_) {
//         setState(() {});
//         _controller.play(); // auto play
//       });
//
//     _controller.setLooping(true); // 🔁 loop ON
//     _controller.setVolume(0.0); // optional (silent video)
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return  Center(
//       child: _controller.value.isInitialized
//           ? AspectRatio(
//         aspectRatio: _controller.value.aspectRatio,
//         child: VideoPlayer(_controller),
//       )
//           : const CircularProgressIndicator(),
//     );
//   }
// }