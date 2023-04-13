import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

class MarvelCharacter {
  final int id;
  final String name;
  final String thumbnailUrl;

  MarvelCharacter({required this.id, required this.name, required this.thumbnailUrl});
}

class MarvelCharactersList extends StatelessWidget {
  final List<MarvelCharacter> characters;

  MarvelCharactersList({required this.characters});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: characters.length,
      itemBuilder: (context, index) {
        final character = characters[index];
        return ListTile(
          title: Text(character.name),
          leading: Image.network(character.thumbnailUrl),
        );
      },
    );
  }
}

Future<List<MarvelCharacter>> fetchMarvelCharacters() async {
  const String publicKey = '59129ed11dd04dc0877aacad252feb7f';
  const String privateKey = 'ac682c537e6aeb149ff5482ea5fc9cada8b16461';
  const String apiUrl = 'https://gateway.marvel.com/v1/public/characters';

  final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
  final hash = md5.convert(utf8.encode('$timestamp$privateKey$publicKey')).toString();

  final response = await http.get(Uri.parse('$apiUrl?apikey=$publicKey&ts=$timestamp&hash=$hash'));

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    final List<dynamic> characterData = jsonResponse['data']['results'];

    final List<MarvelCharacter> characters = characterData.map((data) {
      return MarvelCharacter(
        id: data['id'],
        name: data['name'],
        thumbnailUrl: data['thumbnail']['path'] + '.' + data['thumbnail']['extension'],
      );
    }).toList();

    return characters;
  } else {
    throw Exception('Failed to fetch Marvel characters. Error: ${response.statusCode}');
  }
}