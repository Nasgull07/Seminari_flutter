import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:seminari_flutter/models/user.dart';
import 'package:seminari_flutter/screens/ChangePasswordScreen.dart';
import 'package:seminari_flutter/screens/EditProfileScreen.dart';
import 'package:seminari_flutter/screens/auth/login_screen.dart';
import 'package:seminari_flutter/screens/borrar_screen.dart';
import 'package:seminari_flutter/screens/details_screen.dart';
import 'package:seminari_flutter/screens/editar_screen.dart';
import 'package:seminari_flutter/screens/imprimir_screen.dart';
import 'package:seminari_flutter/screens/home_screen.dart';
import 'package:seminari_flutter/screens/perfil_screen.dart';
import 'package:seminari_flutter/services/auth_service.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AuthService().isLoggedIn ? '/' : '/login',
  routes: [
    GoRoute(path: '/login', builder: (context, state) => LoginPage()),
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          path: 'details',
          builder: (context, state) => const DetailsScreen(),
          routes: [
            GoRoute(
              path: 'imprimir',
              builder: (context, state) => const ImprimirScreen(),
            ),
          ],
        ),
        GoRoute(
          path: 'editar',
          builder: (context, state) => const EditarScreen(),
        ),
        GoRoute(
          path: 'borrar',
          builder: (context, state) => const BorrarScreen(),
        ),
        GoRoute(
          path: 'profile',
          builder: (context, state) {
              final userId = state.extra as String?;
              if (userId == null) {
                return const Center(child: Text('Error: No se proporcionó un ID de usuario.'));
              }
              return PerfilScreen(userId: userId);
          },
        ),

        GoRoute(
          path: '/profile/edit',
          builder: (context, state) {
            final user = state.extra as User; // Obtén el usuario desde `state.extra`
            return EditProfileScreen(user: user);
          },
        ),

        GoRoute(
          path: '/profile/change-password',
          builder: (context, state) {
            final userId = state.extra as String; // Obtén el userId desde `state.extra`
            return ChangePasswordScreen(userId: userId);
          },
        ),
      ],
    ),
  ],
);
