import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mannfleet/presentaion/auth/login/provider/loginProvider.dart';
import 'package:mannfleet/presentaion/auth/otp/otpProvider/otpProvider.dart';
import 'package:mannfleet/presentaion/booking/provider/bookingSummaryProvider.dart';
import 'package:mannfleet/presentaion/bookingHistory/provider/bookingHistoryProvider.dart';
import 'package:mannfleet/presentaion/cms/viewModel/cmsPro.dart';
import 'package:mannfleet/presentaion/home/provider/homeProvider.dart';
import 'package:mannfleet/presentaion/newComplaints/viewModel/complaintsPro.dart';
import 'package:mannfleet/presentaion/notification/viewModel/NotificationPro.dart';
import 'package:mannfleet/presentaion/onBording/provider/onBordingProvider.dart';
import 'package:mannfleet/presentaion/profile/viewModel/profileViewModel.dart';
import 'package:mannfleet/presentaion/splash/provider/provider.dart';
import 'package:mannfleet/presentaion/splash/ui/splashScreen.dart';
import 'package:mannfleet/util/theame/app_theme.dart';
import 'package:provider/provider.dart';
import 'apiservice/services/firebaseService.dart';
// import 'firebase_options.dart';
void main() {
 // WidgetsFlutterBinding.ensureInitialized();

  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  /// Initialize Firebase Service
  // await FirebaseService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers:[
        ChangeNotifierProvider(create: (_) => OnBordingProvider(),),
        ChangeNotifierProvider(create: (_) => PlatformDependenciesPro(),),
        ChangeNotifierProvider(create: (_) => LoginProvider(),),
        ChangeNotifierProvider(create: (_) => OtpProvider(),),
        ChangeNotifierProvider(create: (_) => HomeProvider(),),
        ChangeNotifierProvider(create: (_) => ProfileDetailViewModel(),),

        ChangeNotifierProvider(create: (_) => BookingSummaryProvider(),),
        ChangeNotifierProvider(create: (_) => BookingHistoryProvider(),),
        ChangeNotifierProvider(create: (_) => CMSProvider(),),
        ChangeNotifierProvider(create: (_) => ComplaintsProvider(),),
        ChangeNotifierProvider(create: (_) => NotificationProvider(),),
      ],
      child: MaterialApp(
        title: 'Mann Fleet',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,

        home: const SplashScreen(),
       // home: const MySupportTickets(),
       // home: const SupportScreen(),
      ),
    );
  }
}

