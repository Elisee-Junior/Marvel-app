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
class MarvelCharactersList extends StatefulWidget {
  @override
  _MarvelCharactersListState createState() => _MarvelCharactersListState();
}

class _MarvelCharactersListState extends State<MarvelCharactersList> {
  ScrollController _scrollController = ScrollController();
  List<MarvelCharacter> characters = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll); // Add scroll listener
    fetchCharacters(); // Fetch initial characters
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll); // Remove scroll listener
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.maxScrollExtent == _scrollController.offset &&
        !isLoading) {
      // When reaching the end of the list, fetch more characters
      fetchCharacters();
    }
  }

  void fetchCharacters() async {
    setState(() {
      isLoading = true; // Set loading state to indicate fetching is in progress
    });

    try {
      List<MarvelCharacter> fetchedCharacters = await fetchMarvelCharacters();
      setState(() {
        characters.addAll(fetchedCharacters); // Add fetched characters to the list
        isLoading = false; // Update loading state to indicate fetching is complete
      });
    } catch (error) {
      setState(() {
        isLoading = false; // Update loading state to indicate fetching is complete
      });
      print('Error fetching Marvel characters: $error');
    }
  }



  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification is ScrollEndNotification &&
            scrollNotification.metrics.extentAfter == 0) {
          // When scroll ends and reaches the end of the list, fetch more characters
          fetchCharacters();
        }
        return false;
      },
      child: ListView.builder(
        controller: _scrollController, // Set the scroll controller
        itemCount: characters.length,
        itemBuilder: (context, index) {
          final character = characters[index];
          return ListTile(
            title: Text(character.name),
            leading: Image.network(character.thumbnailUrl),
          );
        },
      ),
    );
  }
}



Future<List<MarvelCharacter>> fetchMarvelCharacters() async {
  final String publicKey = '59129ed11dd04dc0877aacad252feb7f';
  final String privateKey = 'ac682c537e6aeb149ff5482ea5fc9cada8b16461';
  final String apiUrl = 'https://gateway.marvel.com/v1/public/characters';

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
    print(characters);
    return characters;
  } else {
    throw Exception('Failed to fetch Marvel characters. Error: ${response.statusCode}');
  }
}