import 'package:flutter/cupertino.dart';

import '../../../widget/navigator_method.dart';
import '../../auth/login/ui/login_screen.dart';

class OnBordingProvider with ChangeNotifier{
  void goToLogin(BuildContext context) {
    navPush(
      context: context,
      action: const LoginScreen(),
    );
  }
}