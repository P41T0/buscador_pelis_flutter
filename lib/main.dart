import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:buscador_pelis_flutter/screens/home.dart';
import 'package:buscador_pelis_flutter/screens/search.dart';

Future<void> main() async {
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.home_rounded)),
                Tab(icon: Icon(Icons.movie_rounded)),
                Tab(icon: Icon(Icons.person_rounded)),
              ],
            ),
            title: const Text('BuscaPelis'),
          ),
          body: const TabBarView(
            children: [
              Home(),
              Search(),
              Center(
                child: Text(
                  "Perfil d'usuari i pel·lícules guardades (per a a afegir en un futur)",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
