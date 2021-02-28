import 'package:amazing_company/screens/detail_screen.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:amazing_company/models/search_data.dart';

class MainScreen extends StatefulWidget {
  final String title;

  MainScreen({this.title});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController _filter = new TextEditingController();
  String _searchText = "";
  List<SearchData> names = [];
  List<SearchData> filteredNames = [];
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text('Search Example');

  _MainScreenState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          filteredNames.addAll(names);
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = Icon(Icons.close);
        this._appBarTitle = TextField(
          controller: _filter,
          decoration: InputDecoration(
              prefixIcon: Icon(Icons.search), hintText: 'Search...'),
        );
      } else {
        this._searchIcon = Icon(Icons.search);
        this._appBarTitle = Text(widget.title);
        _filter.clear();
        filteredNames.clear();
      }
    });
  }

  Widget _buildList() {
    if (!(_searchText.isEmpty)) {
      List<SearchData> tempList = [];
      for (int i = 0; i < filteredNames.length; i++) {
        if (filteredNames[i]
            .name
            .toLowerCase()
            .contains(_searchText.toLowerCase())) {
          tempList.add(filteredNames[i]);
        }
      }
      filteredNames = tempList;
    }
    return ListView.builder(
      itemCount: names == null ? 0 : filteredNames?.length,
      itemBuilder: (BuildContext context, int index) {
        return new ListTile(
          key: ValueKey(filteredNames[index].objectId),
          title: Text(filteredNames[index].name),
          onTap: () => Navigator.of(context).pushNamed(DetailScreen.routeName,
              arguments: SearchData(
                  name: filteredNames[index].name,
                  objectId: filteredNames[index].objectId,
                  points: filteredNames[index].points)),
        );
      },
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      centerTitle: true,
      title: _appBarTitle,
      leading: new IconButton(
        icon: _searchIcon,
        onPressed: _searchPressed,
      ),
    );
  }

  void _initialization() async {
    names = await Provider.of<SeachHelper>(context, listen: false)
        .fetchSeachResult();
  }

  bool _isLoaded = false;

  @override
  void initState() {
    _isLoaded = true;
    _initialization();
    _isLoaded = false;
    super.initState();
  }

  @override
  void dispose() {
    _filter.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: _isLoaded
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              child: _buildList(),
            ),
      resizeToAvoidBottomPadding: false,
    );
  }
}
