

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../api/getCharacter.dart';

class herosList extends StatefulWidget {
  const herosList({super.key});

  @override
  _herosListState createState() => _herosListState();
}

class _herosListState extends State<herosList> {
  Icon _searchIcon = const Icon(
    Icons.search,
  );
  bool isSearchClicked = false;
  final TextEditingController _filter = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
            return <Widget>[
              createSilverAppBar()
            ];
          },
          body: FutureBuilder<List<MarvelCharacter>>(
          future: fetchMarvelCharacters(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // final characters = snapshot.data!;
              return MarvelCharactersList();
            } else if (snapshot.hasError) {
              return Text('Failed to fetch Marvel characters. Error: ${snapshot.error}');
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red), // Set color of CircularProgressIndicator
                  strokeWidth: 5.0, // Set strokeWidth of CircularProgressIndicator
                ),
              );
            }
          },
        ),
      ),
    );
  }

  SliverAppBar createSilverAppBar() {
    return SliverAppBar(
      actions: <Widget>[
        RawMaterialButton(
          elevation: 0.0,
          // ignore: sort_child_properties_last
          child: _searchIcon,
          onPressed: () {
            _searchPressed();
          },
          constraints: const BoxConstraints.tightFor(
            width: 56,
            height: 56,
          ),
          shape: const CircleBorder(),
        ),
        
      ],
      expandedHeight: 300,
      floating: false,
      pinned: true,
        flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(bottom: 15),
        centerTitle: true,
        title:isSearchClicked ? Container(
          padding: const EdgeInsets.only(bottom: 2),
          constraints:
              const BoxConstraints(minHeight: 40, maxHeight: 40),
          width: 220,
          child: CupertinoTextField(
            controller: _filter,
            keyboardType: TextInputType.text,
            placeholder: "Search..",
            placeholderStyle: const TextStyle(
              color: Color(0xffC4C6CC),
              fontSize: 14.0,
              fontFamily: 'Brutal',
            ),
            prefix: const Padding(
              padding:
                  EdgeInsets.fromLTRB(9.0, 6.0, 9.0, 6.0),
              child: Icon(Icons.search, ),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.white,
            ),
          ),
        ) : const Text("Heros Wiki"),
        background: Image.network("https://th.bing.com/th/id/R.0a32abf0e9836c1d8cc0a08d24dc8ff7?rik=%2fv27gLeIjcYSAw&pid=ImgRaw&r=0", fit: BoxFit.cover,)
      ),
      backgroundColor:Color(0xffff1c24),
    );
  }

  void _searchPressed() {
    setState(() {
      if (_searchIcon.icon == Icons.search) {
        _searchIcon = const Icon(
          Icons.close,
        );
        isSearchClicked = true;
      } else {
        _searchIcon = const Icon(
          Icons.search,
          
        );
        isSearchClicked = false;
        _filter.clear();
      }
    });
  }
}