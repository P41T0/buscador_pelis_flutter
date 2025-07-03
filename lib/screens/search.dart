import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:developer';
import 'dart:convert';

class Search extends StatefulWidget {
  const Search({super.key});
  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String _textCerca = "";
  String errorMessage = "";
  late List<dynamic> filmsData = [];

  Future<void> fetchData() async {
    setState(() {
      filmsData = [];
    });
    final apiUrlSearch = dotenv.env['API_URL_SEARCH'] ?? '';
    final apiKey = dotenv.env['API_KEY'] ?? '';
    final encodedPelicula = Uri.encodeQueryComponent(_textCerca);
    final url = Uri.parse(
      '${apiUrlSearch}query=$encodedPelicula&language=es-ES&api_key=$apiKey',
    );
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          final decodedData = json.decode(response.body);
          filmsData = decodedData['results'];
          errorMessage =
              "S'han trobat un total de ${filmsData.length.toString()} pel·lícules";
        });
      } else {
        throw Exception('failed to get movies');
      }
    } catch (e) {
      log(e.toString());
      setState(() {
        filmsData = [];
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 250,
                child: TextField(
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
                    border: OutlineInputBorder(),
                    labelText: 'Cerca la pel·lícula',
                  ),
                  onEditingComplete: () {
                    if (_textCerca.length >= 3) {
                      fetchData();
                    } else if (_textCerca.length < 3) {
                      setState(() {
                        errorMessage =
                            "Has d'introduir un mínim de 3 caràcters";
                      });
                    }
                  },
                  onChanged: (String text) {
                    _textCerca = text;
                    setState(() {
                      errorMessage = "";
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  if (_textCerca.length >= 3) {
                    fetchData();
                  } else if (_textCerca.length < 3) {
                    setState(() {
                      errorMessage = "Has d'introduir un mínim de 3 caràcters";
                    });
                  }
                },
                child: const Row(
                  children: [
                    Text("Buscar la pel·lícula"),
                    SizedBox(width: 15),
                    Icon(Icons.search),
                  ],
                ),
              ),
            ],
          ),
          Text(
            errorMessage,
            style: const TextStyle(fontStyle: FontStyle.italic),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(left: 50, bottom: 20, top: 30),
              itemCount: filmsData.length,
              itemBuilder: (context, index) {
                if (filmsData[index]['poster_path'] != null) {
                  return Card(
                    child: ListTile(
                      title: Text(
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                        filmsData[index]['title'],
                      ),
                      subtitle: Text(
                        "Pel·lícula estrenada el dia ${filmsData[index]['release_date']}",
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                      leading: Image.network(
                        'https://image.tmdb.org/t/p/w200${filmsData[index]['poster_path']}',
                        width: 50,
                        height: 75,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetailScreen(film: filmsData[index]),
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return Card(
                    child: ListTile(
                      title: Text(
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                        filmsData[index]['title'],
                      ),
                      subtitle: Text(
                        "Pel·lícula estrenada el dia ${filmsData[index]['release_date']}",
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                      leading: const FlutterLogo(),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetailScreen(film: filmsData[index]),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.film});

  // Declare a field that holds the Todo.
  final dynamic film;

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    if (film['poster_path'] != null) {
      return Scaffold(
        appBar: AppBar(title: Text(film['title'])),
        body: Container(
          margin: const EdgeInsets.all(20.0),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    film['title'],
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Nom original: ${film['original_title']} (${film['original_language']})",
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Pel·lícula estrenada el dia ${film['release_date']}",
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 10),
                  Image.network(
                    'https://image.tmdb.org/t/p/w200${film['poster_path']}',
                    width: 200,
                    height: 300,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Descripció: ${film['overview']}",
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    textAlign: TextAlign.center,
                    "La pel·lícula té una valoració de ${film['vote_average']} punts sobre 10, amb valoracions de ${film['vote_count']} usuaris.",
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(title: Text(film['title'])),
        body: Container(
          margin: const EdgeInsets.all(20.0),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    film['title'],
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Nom original: ${film['original_title']} (${film['original_language']})",
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text("La pel·lícula no disposa de póster"),
                  const SizedBox(height: 10),
                  Text(
                    "Pel·lícula estrenada el dia ${film['release_date']}",
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Descripció: ${film['overview']}",
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    textAlign: TextAlign.center,
                    "La pel·lícula té una valoració de ${film['vote_average']} punts sobre 10, amb valoracions de ${film['vote_count']} usuaris.",
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}
