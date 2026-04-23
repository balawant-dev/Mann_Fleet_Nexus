
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../error_screens/no_internet_screen.dart';
import '../error_screens/server_error_screen.dart';


Future<bool> hasInternet() async {
  final connectivityResult = await Connectivity().checkConnectivity();
  return connectivityResult != ConnectivityResult.none;
}

void showNoInternetScreen(BuildContext context, {VoidCallback? onRetry}) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => NoInternetScreen(onRetry: onRetry),
    ),
  );
}

void showServerErrorScreen(BuildContext context, {VoidCallback? onRetry}) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => ServerErrorScreen(onRetry: onRetry),
    ),
  );
}