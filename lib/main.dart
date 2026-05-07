import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'models/tarefa.dart';
import 'providers/tarefas_provider.dart';
import 'providers/etiquetas_provider.dart';
import 'screens/tela_boas_vindas.dart';
import 'screens/tela_form_tarefa.dart';
import 'screens/tela_detalhes.dart';
import 'screens/tela_etiquetas.dart';
import 'screens/tela_listagem.dart';
import 'utils/rotas.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AppTarefas());
}

class AppTarefas extends StatelessWidget {
  const AppTarefas({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TarefasProvider()),
        ChangeNotifierProvider(create: (_) => EtiquetasProvider()),
      ],
      child: MaterialApp(
        title: 'App Tarefas',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF81C784)),
          useMaterial3: true,
              appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF81C784),
            foregroundColor: Colors.white,
            elevation: 2,
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Color(0xFF81C784),
            foregroundColor: Colors.white,
          ),
        ),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('pt', 'BR')],
        initialRoute: Rotas.boasVindas,
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case Rotas.boasVindas:
              return MaterialPageRoute(builder: (_) => const TelaBoasVindas());
            case Rotas.listagem:
              return MaterialPageRoute(builder: (_) => const TelaListagem());
              case Rotas.inserirTarefa:                                         
              return MaterialPageRoute(builder: (_) => const TelaFormTarefa());
            case Rotas.editarTarefa:
              final tarefa = settings.arguments as Tarefa;
              return MaterialPageRoute(builder: (_) => TelaFormTarefa(tarefaParaEditar: tarefa));
            case Rotas.detalhesTarefa:
              return MaterialPageRoute(
                settings: settings,
                builder: (_) => const TelaDetalhes(),
              );
            case Rotas.etiquetas:
              return MaterialPageRoute(builder: (_) => const TelaEtiquetas());
            default:
              return MaterialPageRoute(builder: (_) => const TelaListagem());
          }
        },
      ),
    );
  }
}