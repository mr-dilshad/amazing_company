import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


//search data model
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

//helper class for search data

class SeachHelper with ChangeNotifier {
  String _urlString = "http://hn.algolia.com/api/v1";
  static List<SearchData> _searchData = [];
  static List<String> _comments = [];

  List<String> get getComments {
    return [..._comments];
  }

  List<SearchData> get getSeachData {
    return [..._searchData];
  }

//method for fetching search results
  Future<List<SearchData>> fetchSeachResult() async {
    var url = "$_urlString/search?query=test";
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

//method for fetching comments
  Future<List<String>> fetchComments(String objectid) async {
    var url = "$_urlString/items/$objectid";
    try {
      final response = await http.get(url);
      final _extractedResult =
          json.decode(response.body) as Map<String, dynamic>;

      if (_extractedResult == null) return [];

      List<String> _loadedSeach = [];
      print('object');
      _extractedResult['children'].forEach((element) {
        _loadedSeach.add(_parseHtmlString(
            element['text'].toString()));
      });

      print(_loadedSeach);

      _comments = _loadedSeach;
      return this.getComments;
    } catch (e) {
      print(e);
    }
  }
//meathod to remove html tags
  String _parseHtmlString(String htmlString) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

    return htmlString.replaceAll(exp, '');
  }
}
