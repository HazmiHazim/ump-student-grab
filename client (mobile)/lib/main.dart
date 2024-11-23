import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ump_student_grab_mobile/BL/auth_service.dart';
import 'package:ump_student_grab_mobile/BL/chat_service.dart';
import 'package:ump_student_grab_mobile/BL/chat_websocket_service.dart';
import 'package:ump_student_grab_mobile/Screen//welcome_screen.dart';
import 'package:ump_student_grab_mobile/Screen/Account/main_account_screen.dart';
import 'package:ump_student_grab_mobile/Screen/Auth/forgot_password_screen.dart';
import 'package:ump_student_grab_mobile/Screen/Auth/login_screen.dart';
import 'package:ump_student_grab_mobile/Screen/Auth/signup_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ump_student_grab_mobile/Screen/Booking/main_booking_screen.dart';
import 'package:ump_student_grab_mobile/Screen/Chat/chat_room_screen.dart';
import 'package:ump_student_grab_mobile/Screen/Chat/main_chat_screen.dart';
import 'package:ump_student_grab_mobile/Screen/home_screen.dart';
import 'package:ump_student_grab_mobile/Screen/search_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(); // Load the .env file
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => AuthService()),
        ChangeNotifierProvider(create: (ctx) =>  ChatService()),
        ChangeNotifierProvider(create: (ctx) => ChatWebsocketService())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: WelcomeScreen(),
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
          "/search-screen": (context) => SearchScreen()
        },
      ),
    );
  }
}