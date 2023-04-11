import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class herosList extends StatefulWidget {
  @override
  _herosListState createState() => _herosListState();
}

class _herosListState extends State<herosList> {
  Icon _searchIcon = Icon(
    Icons.search,
  );
  bool isSearchClicked = false;
  final TextEditingController _filter = new TextEditingController();
  
  List<String> itemList = [];

  @override
  void initState() {

    for(int count = 0; count < 50; count++)
    {
      itemList.add("Item $count");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
            return <Widget>[
              createSilverAppBar()
            ];
          },
          body: ListView.builder(
            itemCount: itemList.length,
            itemBuilder: (context, index){
              return Card(
                child: ListTile(
                  title: Text(itemList[index]),
                ),
              );
          })),
    );
  }

  SliverAppBar createSilverAppBar() {
    return SliverAppBar(
      actions: <Widget>[
        RawMaterialButton(
          elevation: 0.0,
          child: _searchIcon,
          onPressed: () {
            _searchPressed();
          },
          constraints: BoxConstraints.tightFor(
            width: 56,
            height: 56,
          ),
          shape: CircleBorder(),
        ),
        
      ],
      expandedHeight: 300,
      floating: false,
      pinned: true,
        flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.only(bottom: 15),
        centerTitle: true,
        title:isSearchClicked ? Container(
          padding: EdgeInsets.only(bottom: 2),
          constraints:
              BoxConstraints(minHeight: 40, maxHeight: 40),
          width: 220,
          child: CupertinoTextField(
            controller: _filter,
            keyboardType: TextInputType.text,
            placeholder: "Search..",
            placeholderStyle: TextStyle(
              color: Color(0xffC4C6CC),
              fontSize: 14.0,
              fontFamily: 'Brutal',
            ),
            prefix: Padding(
              padding:
                  const EdgeInsets.fromLTRB(9.0, 6.0, 9.0, 6.0),
              child: Icon(Icons.search, ),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.white,
            ),
          ),
        ) : Text("Heros Wiki"),
        background: Image.network("https://th.bing.com/th/id/R.0a32abf0e9836c1d8cc0a08d24dc8ff7?rik=%2fv27gLeIjcYSAw&pid=ImgRaw&r=0", fit: BoxFit.cover,)
      ),
      backgroundColor:Color(0xffff1c24),
    );
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = Icon(
          Icons.close,
        );
        isSearchClicked = true;
      } else {
        this._searchIcon = Icon(
          Icons.search,
          
        );
        isSearchClicked = false;
        _filter.clear();
      }
    });
  }
}