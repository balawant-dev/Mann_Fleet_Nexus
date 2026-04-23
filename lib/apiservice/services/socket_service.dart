//
// import 'dart:convert';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
// import 'package:awesome_notifications/awesome_notifications.dart';
// import '../constants/api_constants.dart';
//
// class SocketService {
//   static final SocketService _instance = SocketService._internal();
//   factory SocketService() => _instance;
//
//   SocketService._internal();
//
//   IO.Socket? _socket;
//   bool _isConnected = false;
//   String? _userId;
//
//   /// 🔌 CONNECT SOCKET (CALL AFTER LOGIN)
//   void connectSocket({required String userId}) {
//     if (_socket != null && _isConnected) return;
//
//     _userId = userId;
//
//     _socket = IO.io(
//       ApiConstants.socketURl,
//       IO.OptionBuilder()
//           .setTransports(['websocket'])
//           .disableAutoConnect()
//           .enableReconnection()
//           .setReconnectionAttempts(10)
//           .setReconnectionDelay(2000)
//           .build(),
//     );
//
//     _socket!.connect();
//
//     /// ✅ CONNECTED
//     _socket!.onConnect((_) {
//       _isConnected = true;
//       print('✅ Socket Connected');
//       _joinRoom();
//     });
//
//     /// 📦 BOOKING CREATED EVENT
//     // _socket!.on('bookingCreated', (data) {
//     //   print('🆕 Booking Created => $data');
//     //   _showBookingNotification(data);
//     // });
//     /// 📦 BOOKING UPDATED EVENT
//     _socket!.on('bookingStatusUpdated', (data) {
//       print('🆕 Booking Status Updated => $data');
//       _showBookingNotification(data);
//     });
//
//     /// 🔔 GENERAL NOTIFICATION EVENT
//     _socket!.on('notification', (data) {
//       print('📩 Notification Received => $data');
//       _showNotification(data);
//     });
//
//     /// ❌ DISCONNECTED
//     _socket!.onDisconnect((_) {
//       _isConnected = false;
//       print('❌ Socket Disconnected');
//     });
//
//     /// 🧨 DEBUG ALL EVENTS
//     _socket!.onAny((event, data) {
//       print('🧨 EVENT => $event | DATA => $data');
//     });
//
//     /// ❌ ERROR HANDLING
//     _socket!.onConnectError((e) {
//       print('❌ Connect Error: $e');
//     });
//
//     _socket!.onError((e) {
//       print('❌ Socket Error: $e');
//     });
//   }
//
//   /// 🚪 JOIN USER ROOM
//   void _joinRoom() {
//     if (!_isConnected || _userId == null) return;
//     _socket!.emit('join', _userId);
//     print('🚪 Joined room => $_userId');
//   }
//
//   /// 🔌 DISCONNECT SOCKET (CALL ON LOGOUT)
//   void disconnectSocket() {
//     _socket?.disconnect();
//     _socket?.dispose();
//     _socket = null;
//     _isConnected = false;
//     _userId = null;
//   }
//
//   /// 🔔 SHOW GENERAL NOTIFICATION
//   void _showNotification(dynamic data) {
//     try {
//       final decoded = data is String ? jsonDecode(data) : data;
//
//       final title = decoded['title'] ?? 'New Notification';
//       final body = decoded['message'] ?? 'You have a message';
//
//       AwesomeNotifications().createNotification(
//         content: NotificationContent(
//           id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
//           channelKey: 'basic_channel',
//           title: title,
//           body: body,
//         ),
//       );
//
//       print('✅ Notification Shown');
//     } catch (e) {
//       print('❌ Notification Error: $e');
//     }
//   }
//
//   /// 📦 SHOW BOOKING CREATED NOTIFICATION
//   void _showBookingNotification(dynamic data) {
//     try {
//       final decoded = data is String ? jsonDecode(data) : data;
//
//       final title = decoded['title'] ?? 'New Booking';
//       final body =
//           decoded['message'] ?? 'A new booking has been created';
//
//       AwesomeNotifications().createNotification(
//         content: NotificationContent(
//           id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
//           channelKey: 'basic_channel',
//           title: title,
//           body: body,
//         ),
//       );
//
//       print('✅ Booking Notification Shown');
//     } catch (e) {
//       print('❌ Booking Notification Error: $e');
//     }
//   }
// }
