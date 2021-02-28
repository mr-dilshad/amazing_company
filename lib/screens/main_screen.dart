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
  //variable for storing fetched data
  List<SearchData> _title = [];
  //variable for storing filtered data
  List<SearchData> _filteredtitle = [];
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text('Search Example');

  _MainScreenState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          _filteredtitle.addAll(_title);
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  //turn to false when data is fetched
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
    super.dispose();
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

  //meathod to fetch and intialize data
  void _initialization() async {
    _title = await Provider.of<SeachHelper>(context, listen: false)
        .fetchSeachResult();
  }

  //callback when title bar's leading icon is pressed
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
        _filteredtitle.clear();
      }
    });
  }

  // list of results below search bar
  Widget _buildList() {
    if (!(_searchText.isEmpty)) {
      List<SearchData> tempList = [];
      for (int i = 0; i < _filteredtitle.length; i++) {
        if (_filteredtitle[i]
            .name
            .toLowerCase()
            .contains(_searchText.toLowerCase())) {
          tempList.add(_filteredtitle[i]);
        }
      }
      _filteredtitle = tempList;
    }
    return ListView.builder(
      itemCount: _title == null ? 0 : _filteredtitle.length,
      itemBuilder: (BuildContext context, int index) {
        return new ListTile(
          key: ValueKey(_filteredtitle[index].objectId),
          title: Text(_filteredtitle[index].name),
          onTap: () => Navigator.of(context).pushNamed(DetailScreen.routeName,
              arguments: SearchData(
                  name: _filteredtitle[index].name,
                  objectId: _filteredtitle[index].objectId,
                  points: _filteredtitle[index].points)),
        );
      },
    );
  }


//title bar widget
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
}
