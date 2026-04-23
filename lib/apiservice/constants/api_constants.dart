class ApiConstants {
  //Live Url
  static const String baseUrl = 'https://admin.mannfleetpartners.com';
  // static const String razorPayKey = 'rzp_test_hCRLFPf6rY3elm';
  // static const String googleApiKey = 'AIzaSyAw5iIsWyZnq8Ejy8jLC2jcKvNRxI5Ll3w';
  // static const String baseUrl = 'https://maan.ablagro.in';
  // static const String baseUrl = 'http://159.89.146.245:9020';

  //Local Url
  // static const String baseUrl = 'http://192.168.1.22:9020';

  static const String verifyOtp = '/api/user/verifyOtp';

  static const String signUp = '/api/user/signUp';
  static const String banner = '/api/user/banner';
  static const String bookingEstimate = '/api/user/bookingEstimate';
  static const String booking = '/api/user/booking';
  static const String sendOtpVerification = '/api/user/phoneVerification/send';
  static const String verifyOtpVerification = '/api/user/phoneVerification/verify';
  static const String checkVerification = '/api/user/phoneVerification/checkVerification';
  static const String profile = '/api/user/profile';
  static const String termsConditions = '/api/user/termsConditions';
  static const String privacyPolicy = '/api/user/privacyPolicy';
  static const String platformDependencies = '/api/user/platformDependencies';
  static const String notification = '/api/user/notifications';
  static const String complaints = '/api/user/complaints';
  static const String myComplaints = '/api/user/myComplaints';
  static const String aboutUs = '/api/user/aboutUs';
  static const String refundPolicy = '/api/user/refundPolicy';
  static const String resendOtp = '/api/v1/users/resend-otp';
  static const String update = '/api/v1/users/update';
  static const String dashboardEndpoint = 'dashboard';
  static const String settingsEndpoint = 'settings';
  static const String uploadEndpoint = 'upload';
  static const token = "auth_token";
  static const onboardingComplete = "onboarding_complete";
  static const String tokenKey = 'token';
  static const String isAgentKey = 'isAgent';
  static const String isUserKey = 'isUser';
  static const String saveUserType = 'saveUserType';
  static const String gemini = 'gemini';
}
