import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class SearchData {
  final String name;
  final String objectId;
  final int points;
  SearchData({this.name, this.objectId, this.points});

  factory SearchData.fromJson(Map<String, dynamic> json) {
    return SearchData(
      name: json[''],
    );
  }
}

class SeachHelper with ChangeNotifier {
  String _urlString = "";
  static List<SearchData> _searchData = [];
  static List<String> _comments = [];

  List<String> get getComments {
    return [..._comments];
  }

  List<SearchData> get getSeachData {
    return [..._searchData];
  }

  Future<List<SearchData>> fetchSeachResult() async {
    var url = "http://hn.algolia.com/api/v1/search?query=test";
    try {
      final response = await http.get(url);
      final _extractedResult =
          json.decode(response.body) as Map<String, dynamic>;

      if (_extractedResult == null) return [];

      List<SearchData> _loadedSeach = [];

      _extractedResult['hits'].forEach((element) {
        _loadedSeach.add(SearchData(
            name: element['title'],
            objectId: element['objectID'].toString(),
            points: element['points']));
      });

      _searchData = _loadedSeach;
      return this.getSeachData;
      // notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<List<String>> fetchComments(String id) async {
    var url = "http://hn.algolia.com/api/v1/items/$id";
    try {
      final response = await http.get(url);
      final _extractedResult =
          json.decode(response.body) as Map<String, dynamic>;

      if (_extractedResult == null) return [];

      List<String> _loadedSeach = [];

      _extractedResult['children'].forEach((element) {
        _loadedSeach.add(element['text']);
      });

      print(_loadedSeach);

      _comments = _loadedSeach;
      return this.getComments;
    } catch (e) {
      print(e);
    }
  }
}
