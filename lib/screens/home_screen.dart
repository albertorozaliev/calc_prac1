import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../logic/app_settings.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
appBar: AppBar(
  title: const Text('Главная страница'),
  centerTitle: true,
  actions: [
    ValueListenableBuilder<ThemeMode>(
      valueListenable: AppSettings.themeMode,
      builder: (context, theme, child) {
        final isDark = theme == ThemeMode.dark;

        return IconButton(
          tooltip: isDark ? 'Светлая тема' : 'Тёмная тема',
          icon: Icon(
            isDark ? Icons.light_mode : Icons.dark_mode,
          ),
          onPressed: AppSettings.toggleTheme,
        );
      },
    ),
  ],
),

      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.calculate,
                  size: 80,
                  color: Colors.deepPurple,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Математические инструменты',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Выберите нужный инструмент',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 35),
                FilledButton.icon(
                  onPressed: () {
                    context.go('/calculator');
                  },
                  icon: const Icon(Icons.calculate),
                  label: const Text('Калькулятор'),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () {
                    context.go('/converter');
                  },
                  icon: const Icon(Icons.currency_exchange),
                  label: const Text('Конвертер валют'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
