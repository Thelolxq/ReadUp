import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:read_up/models/user.dart';
import 'package:read_up/navigation/navigation_menu.dart';
import 'package:read_up/provider/session_provider.dart';
import 'package:read_up/screens/singIn/welcome_screen.dart';
import 'package:read_up/services/auth_service.dart';
import 'package:read_up/services/profile_service.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final AuthService _authService = AuthService();
  final ProfileService _profileService = ProfileService();

  late final Future<void> _initFuture;

  @override
  void initState() {
    _initFuture = _tryAutoLogout();
  }

  Future<void> _tryAutoLogout() async {
    final sessionProvider = context.read<SessionProvider>();

    final String? token = await _authService.getToken();

    if (token == null || token.isEmpty) {
      return;
    }

    try {
      final User user = await _profileService.getProfileWithToken(token);
      sessionProvider.setUser(user);
    } catch (error) {
      await _authService.deleteToken();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              backgroundColor: const Color.fromARGB(255, 21, 101, 192),
              body: Center(
                  child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                    colors: <Color>[
                      Colors.blue.shade800,
                      Colors.cyan.shade300,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds);
                },
                child: const CircularProgressIndicator(
                  strokeWidth: 5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )),
            );
          }

          return Consumer<SessionProvider>(builder: (context, session, child) {
            if (session.isLoggedIn) {
              return NavigationMenu();
            } else {
              return const WelcomeScreen();
            }
          });
        });
  }
}
