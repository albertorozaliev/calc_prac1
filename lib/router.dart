
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/converter_screen.dart';
import 'screens/home_screen.dart';
import 'screens/calculator_screen.dart';
import 'screens/result_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),

    GoRoute(
      path: '/calculator',
      builder: (context, state) => const CalculatorScreen(),
    ),

    GoRoute(
  path: '/converter',
  builder: (context, state) => const ConverterScreen(),
),

    GoRoute(
      path: '/result',
      builder: (context, state) => const ResultScreen(),
    ),
  ],
  errorBuilder: (context, state) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ошибка'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 70,
              color: Colors.red,
            ),
            const SizedBox(height: 15),
            const Text(
              'Страница не найдена',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 10),
            Text('Адрес: ${state.uri.path}'),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () => context.go('/'),
              child: const Text('На главную'),
            ),
          ],
        ),
      ),
    );
  },
);
