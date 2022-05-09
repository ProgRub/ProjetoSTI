import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Search extends SearchDelegate {
  late String selectedResult;
  final List<String> suggestions;
  late List<String> recentList;
  Search(this.suggestions);
  @override
  List<Widget>? buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: Icon(Icons.close))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      child: Center(child: Text(selectedResult)),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestionsList = [];
    query.isEmpty
        ? suggestionsList = recentList
        : suggestionsList
            .addAll(suggestions.where((element) => element.contains(query)));
    return ListView.builder(
        itemCount: suggestionsList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(suggestionsList[index]),
            onTap: () {
              selectedResult = suggestionsList[index];
            },
          );
        });
  }
}
