import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:go_router/go_router.dart';
import 'pages/auth_page/auth_page.dart';
import 'pages/lobby_page/lobby_page.dart';
import 'themes/dark_theme.dart';
import 'themes/light_theme.dart';

void main() {
  setUrlStrategy(PathUrlStrategy());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final GoRouter _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) {
          return const StartAuthPage();
        },
      ),
      GoRoute(
        path: '/lobby/:id/:username',
        builder: (context, state) {
          final lobbyId = state.pathParameters['id']!;
          final username = state.pathParameters['username']!;
          return LobbyPage(
            lobbyId: lobbyId,
            userName: username,
          );
        },
      ),
    ],
  );

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: getLightTheme(),
      darkTheme: getDarkTheme(),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      title: 'Крестики-Нолики',
    );
  }
}
