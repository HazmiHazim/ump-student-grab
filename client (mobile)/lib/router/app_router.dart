import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ump_student_grab_mobile/features/account/presentation/screen/main_account_screen.dart';
import 'package:ump_student_grab_mobile/features/account/presentation/screen/personal_information_screen.dart';
import 'package:ump_student_grab_mobile/features/auth/model/user.dart';
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
  bool _showWelcome = false;

  _RouterNotifier(this._ref) {
    _ref.listen<AsyncValue<User?>>(authNotifierProvider, (prev, next) {
      final wasLoggedIn = prev?.valueOrNull != null;
      final isLoggedIn = next.valueOrNull != null;
      if (wasLoggedIn != isLoggedIn) notifyListeners();
    });
    _checkFirstTime();
  }

  Future<void> _checkFirstTime() async {
    final repo = _ref.read(authRepositoryProvider);
    _showWelcome = await repo.isFirstTime();
    notifyListeners();
  }

  void welcomeDone() {
    _showWelcome = false;
    notifyListeners();
  }

  bool get isLoggedIn =>
      _ref.read(authNotifierProvider).valueOrNull != null;
}

final routerNotifierProvider = Provider<_RouterNotifier>((ref) {
  return _RouterNotifier(ref);
});

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = ref.read(routerNotifierProvider);

  return GoRouter(
    refreshListenable: notifier,
    initialLocation: '/auth/welcome',
    redirect: (context, state) {
      final loggedIn = notifier.isLoggedIn;
      final isAuthRoute = state.matchedLocation.startsWith('/auth');
      final isWelcome = state.matchedLocation == '/auth/welcome';

      // First-time user: show welcome screen
      if (notifier._showWelcome) {
        return isWelcome ? null : '/auth/welcome';
      }

      // Not first time but on welcome: skip to login
      if (isWelcome) return '/auth/login';

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
        builder: (context, state) {
          final args = state.extra;
          if (args is! SignupArgs) {
            return _ErrorPage(
              message: 'Something went wrong. Please try again.',
              onRetry: () => context.go('/auth/signup'),
            );
          }
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
                  builder: (context, state) {
                    final args = state.extra;
                    if (args is! ChatRoomArgs) {
                      return _ErrorPage(
                        message: 'Could not open chat. Please try again.',
                        onRetry: () => context.go('/chat'),
                      );
                    }
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

class _ErrorPage extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorPage({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onRetry,
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
