import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'model/pokemon_model.dart';

class PokemonPage extends StatefulWidget {
  const PokemonPage({super.key});

  @override
  State<PokemonPage> createState() => _PokemonPageState();
}

class _PokemonPageState extends State<PokemonPage> {
  List<PokemonModel> pokemonList = [];

  @override
  void initState() {
    fetchApi();
    super.initState();
  }

  Future<void> fetchApi() async {
    var url = Uri.https('pokeapi.co', '/api/v2/pokemon');
    var response = await http.get(url);

    final pokemonJsonBody = jsonDecode(response.body);
    var pokemonResponse = PokemonResponse.fromJson(pokemonJsonBody);

    print(pokemonResponse.results);

    setState(() {
      pokemonList = pokemonResponse.results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Pokemon"),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: pokemonList.length,
          itemBuilder: (context, index) {
            return Container(
              padding: EdgeInsets.all(8),
              child: Text(pokemonList[index].name),
            );
          },
        ),
      ),
    );
  }
}
