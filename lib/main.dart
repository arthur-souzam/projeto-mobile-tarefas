import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AppTarefas());
}

class AppTarefas extends StatelessWidget {
  const AppTarefas({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Tarefas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1565C0)),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1565C0),
          foregroundColor: Colors.white,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text('App Tarefas')),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle_outline, size: 80, color: Colors.blue),
              SizedBox(height: 16),
              Text('teste...', style: TextStyle(fontSize: 20)),
            ],
          ),
        ),
      ),
    );
  }
}
