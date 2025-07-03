import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'dart:developer';
import 'dart:convert';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<dynamic> popularFilms = [];
  Future<void> fetchData() async {
    setState(() {
      popularFilms = [];
    });
    final apiUrlRecent = dotenv.env['API_URL_RECENT'] ?? '';
    final apiKey = dotenv.env['API_KEY'] ?? '';
    final url = Uri.parse('${apiUrlRecent}language=es-ES&&api_key=$apiKey');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          final decodedData = json.decode(response.body);
          popularFilms = decodedData['results'];
        });
      } else {
        throw Exception('failed to get movies');
      }
    } catch (e) {
      log(e.toString());
      setState(() {
        popularFilms = [];
      });
    }
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          const Text(
            "Últimes estrenes",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(left: 50, bottom: 20, top: 30),
              itemCount: popularFilms.length,
              itemBuilder: (context, index) {
                if (popularFilms[index]['poster_path'] != null) {
                  return Card(
                    child: ListTile(
                      style: ListTileStyle.list,
                      titleAlignment: ListTileTitleAlignment.center,
                      title: Text(
                        "${popularFilms[index]['title']}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        children: [
                          Text(
                            "Disponible a partir del dia ${popularFilms[index]['release_date']}",
                            style: const TextStyle(fontStyle: FontStyle.italic),
                          ),
                          const SizedBox(height: 10),
                          Image.network(
                            'https://image.tmdb.org/t/p/w300${popularFilms[index]['poster_path']}',
                            width: 300,
                            height: 400,
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Card(
                    child: ListTile(
                      style: ListTileStyle.list,
                      titleAlignment: ListTileTitleAlignment.center,
                      title: Text(
                        "${popularFilms[index]['title']}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        children: [
                          Text(
                            "Disponible a partir del dia ${popularFilms[index]['release_date']}",
                            style: const TextStyle(fontStyle: FontStyle.italic),
                          ),
                          const SizedBox(height: 10),
                          const FlutterLogo(),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              fetchData();
            },
            child: const Text(
              "Tornar a carregar la llista de les últimes estrenes",
            ),
          ),
        ],
      ),
    );
  }
}
