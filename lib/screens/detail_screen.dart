import 'package:amazing_company/constants/color_constants.dart';
import 'package:amazing_company/models/search_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailScreen extends StatelessWidget {
  static String routeName = '/detailScreen';


  @override
  Widget build(BuildContext context) {
    final SearchData selectedData = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          selectedData.name,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(10.0),
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: kPrimaryColorLight,
            ),
            child: Text('Points : ${selectedData.points.toString()}',style: TextStyle(color: kPrimaryColorDark),),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: FutureBuilder(
                future: Provider.of<SeachHelper>(context)
                    .fetchComments(selectedData.objectId),
                builder: (context, snapshot) =>
                    snapshot.connectionState == ConnectionState.done
                        ? ListView.builder(
                            itemBuilder: (context, index) => ListTile(
                              title: Text(snapshot.data[index]),
                            ),
                            itemCount: snapshot.data.length,
                          )
                        : Center(
                            child: CircularProgressIndicator(),
                          )),
          ),
        ],
      ),
    );
  }
}
