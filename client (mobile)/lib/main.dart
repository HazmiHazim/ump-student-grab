import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ump_student_grab_mobile/BL/auth_service.dart';
import 'package:ump_student_grab_mobile/BL/chat_service.dart';
import 'package:ump_student_grab_mobile/BL/chat_websocket_service.dart';
import 'package:ump_student_grab_mobile/BL/location_service.dart';
import 'package:ump_student_grab_mobile/Screen//welcome_screen.dart';
import 'package:ump_student_grab_mobile/Screen/Account/main_account_screen.dart';
import 'package:ump_student_grab_mobile/Screen/Auth/forgot_password_screen.dart';
import 'package:ump_student_grab_mobile/Screen/Auth/login_screen.dart';
import 'package:ump_student_grab_mobile/Screen/Auth/signup_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ump_student_grab_mobile/Screen/Booking/main_booking_screen.dart';
import 'package:ump_student_grab_mobile/Screen/Chat/chat_room_screen.dart';
import 'package:ump_student_grab_mobile/Screen/Chat/main_chat_screen.dart';
import 'package:ump_student_grab_mobile/Screen/Home/home_screen.dart';
import 'package:ump_student_grab_mobile/Screen/Home/map_screen.dart';
import 'package:ump_student_grab_mobile/util/location_manager_util.dart';
import 'package:ump_student_grab_mobile/util/shared_preferences_util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(); // Load the .env file
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Check if it's the first time the app is opened
  //final isFirstTime = await SharedPreferencesUtil.isFirstTime();

  // Initialize LocationManagerUtil
  LocationManagerUtil.shared.initLocation();

  runApp(MyApp(/*isFirstTime: isFirstTime*/));
}

class MyApp extends StatelessWidget {
  //final bool isFirstTime;

  // Constructor that accepts the `isFirstTime` flag
  //MyApp({ this.isFirstTime = false });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => AuthService()),
        ChangeNotifierProvider(create: (ctx) =>  ChatService()),
        ChangeNotifierProvider(create: (ctx) => ChatWebsocketService()),
        ChangeNotifierProvider(create: (ctx) => LocationService())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: WelcomeScreen(),//isFirstTime ? WelcomeScreen() : LoginScreen(),
        routes: {
          "/welcome-screen": (context) => WelcomeScreen(),
          "/signup-screen": (context) => SignupScreen(),
          "/login-screen": (context) => LoginScreen(),
          "/forgot-password-screen": (context) => ForgotPasswordScreen(),
          "/home-screen": (context) => HomeScreen(),
          "/main-booking-screen": (context) => MainBookingScreen(),
          "/main-chat-screen": (context) => MainChatScreen(),
          "/main-account-screen": (context) => MainAccountScreen(),
          "/chat-room-screen": (context) => ChatRoomScreen(),
          "/map-screen": (context) => MapScreen()
        },
      ),
    );
  }
}