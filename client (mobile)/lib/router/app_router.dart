import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ump_student_grab_mobile/features/account/presentation/screen/main_account_screen.dart';
import 'package:ump_student_grab_mobile/features/account/presentation/screen/personal_information_screen.dart';
import 'package:ump_student_grab_mobile/features/auth/domain/entity/user.dart';
import 'package:ump_student_grab_mobile/features/auth/presentation/providers.dart';
import 'package:ump_student_grab_mobile/features/auth/presentation/screen/create_password_screen.dart';
import 'package:ump_student_grab_mobile/features/auth/presentation/screen/forgot_password_screen.dart';
import 'package:ump_student_grab_mobile/features/auth/presentation/screen/login_screen.dart';
import 'package:ump_student_grab_mobile/features/auth/presentation/screen/signup_args.dart';
import 'package:ump_student_grab_mobile/features/auth/presentation/screen/signup_screen.dart';
import 'package:ump_student_grab_mobile/features/auth/presentation/screen/welcome_screen.dart';
import 'package:ump_student_grab_mobile/features/booking/presentation/screen/main_booking_screen.dart';
import 'package:ump_student_grab_mobile/features/booking/presentation/screen/map_screen.dart';
import 'package:ump_student_grab_mobile/features/chat/presentation/screen/chat_room_args.dart';
import 'package:ump_student_grab_mobile/features/chat/presentation/screen/chat_room_screen.dart';
import 'package:ump_student_grab_mobile/features/chat/presentation/screen/main_chat_screen.dart';
import 'package:ump_student_grab_mobile/features/home/presentation/screen/home_screen.dart';
import 'package:ump_student_grab_mobile/features/home/presentation/shell/app_shell.dart';

class _RouterNotifier extends ChangeNotifier {
  final Ref _ref;
  _RouterNotifier(this._ref) {
    _ref.listen<AsyncValue<User?>>(authNotifierProvider, (_, __) {
      notifyListeners();
    });
  }

  bool get isLoggedIn =>
      _ref.read(authNotifierProvider).valueOrNull != null;
}

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = _RouterNotifier(ref);

  return GoRouter(
    refreshListenable: notifier,
    initialLocation: '/auth/login',
    redirect: (context, state) {
      final loggedIn = notifier.isLoggedIn;
      final isAuthRoute = state.matchedLocation.startsWith('/auth');

      if (!loggedIn && !isAuthRoute) return '/auth/login';
      if (loggedIn && isAuthRoute) return '/home';
      return null;
    },
    routes: [
      // Auth routes
      GoRoute(
        path: '/auth/welcome',
        builder: (_, __) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/auth/login',
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: '/auth/signup',
        builder: (_, __) => const SignupScreen(),
      ),
      GoRoute(
        path: '/auth/forgot-password',
        builder: (_, __) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/auth/create-password',
        builder: (_, state) {
          final args = state.extra as SignupArgs;
          return CreatePasswordScreen(args: args);
        },
      ),

      // Main app shell with bottom navigation
      StatefulShellRoute.indexedStack(
        builder: (_, __, shell) => AppShell(navigationShell: shell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/home',
              builder: (_, __) => const HomeScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/booking',
              builder: (_, __) => const MainBookingScreen(),
              routes: [
                GoRoute(
                  path: 'map',
                  builder: (_, __) => const MapScreen(),
                ),
              ],
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/chat',
              builder: (_, __) => const MainChatScreen(),
              routes: [
                GoRoute(
                  path: 'room',
                  builder: (_, state) {
                    final args = state.extra as ChatRoomArgs;
                    return ChatRoomScreen(args: args);
                  },
                ),
              ],
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/account',
              builder: (_, __) => const MainAccountScreen(),
              routes: [
                GoRoute(
                  path: 'personal-info',
                  builder: (_, __) => const PersonalInformationScreen(),
                ),
              ],
            ),
          ]),
        ],
      ),
    ],
  );
});
