import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:projeto_sti/api/movies.dart';
import 'package:projeto_sti/api/tvShows.dart';

import '../models/person.dart';

class PersonsAPI {
  PersonsAPI._privateConstructor();

  static final PersonsAPI _instance = PersonsAPI._privateConstructor();

  CollectionReference<Map<String, dynamic>> collection =
      FirebaseFirestore.instance.collection('persons');

  factory PersonsAPI() {
    return _instance;
  }
  Future<Person> getPersonByID(String id) async =>
      Person.fromApi(await collection.doc(id).get());

  Future<List<Person>> getPeople(List<String> ids) async {
    List<Person> returnPeople = [];
    for (var id in ids) {
      var person = await collection.doc(id).get();
      returnPeople.add(Person.fromApi(person));
    }
    return returnPeople;
  }

  Future<List<Person>> getAllPeople() async {
    clearPeopleNotBeingUsed();
    var people = await collection.get();
    List<Person> returnPeople = [];
    for (var person in people.docs) {
      if (person["photo"].isEmpty) print("NO PHOTO " + person["name"]);
      returnPeople.add(Person.fromApi(person));
      // print(returnPeople.last.name);
    }
    return returnPeople;
  }

  Future<void> clearPeopleNotBeingUsed() async {
    var movies = await MoviesAPI().getAllMovies();
    var shows = await TVShowsAPI().getAllTvShows();
    var people = await collection.get();
    for (var person in people.docs) {
      if (!movies.any((element) => element.cast.contains(person.id)) &&
          !shows.any((element) => element.cast.contains(person.id)) &&
          !movies.any((element) => element.directors.contains(person.id)) &&
          !shows.any((element) => element.directors.contains(person.id)) &&
          !movies.any((element) => element.writers.contains(person.id)) &&
          !shows.any((element) => element.writers.contains(person.id))) {
        print("DELETING " + person.id);
        collection.doc(person.id).delete();
      }
    }
  }

  Future<String> addPersonIfNotInDB(String actorName, String type) async {
    var people = await collection.get();
    // print("GETTING " + actorName);
    if (!actorName.contains(" ")) {
      var person = await collection.doc(actorName).get();
      if (!person["type"].contains(type)) {
        collection.doc(actorName).update({"type": person["type"] + "," + type});
      }
      return actorName;
    }
    if (people.docs.any((element) => element["name"] == actorName)) {
      var person =
          people.docs.firstWhere((element) => element["name"] == actorName);
      if (!person["type"].contains(type)) {
        collection.doc(person.id).update({"type": person["type"] + "," + type});
      }
      return person.id;
    }
    print("GETTING: " + actorName + " " + type);
    print("SUMMARY");
    try {
      Response resSummary = await get(Uri.parse(
          "https://en.wikipedia.org/w/api.php?format=json&action=query&prop=extracts&exintro&explaintext&redirects=1&titles=${actorName.replaceAll(" ", "%20")}"));

      var summary = "";
      if (resSummary.statusCode == 200) {
        var body = jsonDecode(resSummary.body);
        // print(index);
        // print(actorName);
        // print(body["query"]["pages"].keys.first);
        var ls = const LineSplitter();
        summary = ls
            .convert(body["query"]["pages"][body["query"]["pages"].keys.first]
                ["extract"])
            .first;
        if (summary.contains("may refer")) {
          resSummary = await get(Uri.parse(
              "https://en.wikipedia.org/w/api.php?format=json&action=query&prop=extracts&exintro&explaintext&redirects=1&titles=${actorName.replaceAll(" ", "%20")}%20(actor)"));
          if (resSummary.statusCode == 200) {
            body = jsonDecode(resSummary.body);
            // print(index);
            // print(actorName);
            // print(body["query"]["pages"].keys.first);
            try {
              summary = ls
                  .convert(body["query"]["pages"]
                      [body["query"]["pages"].keys.first]["extract"])
                  .first;
            } catch (e) {}
            // print(summary); //
          }
        }
        // print(summary); //["extract"]
      } else {
        throw "Unable to retrieve info.";
      }
      const monthNames = [
        "January",
        "February",
        "March",
        "April",
        "May",
        "June",
        "July",
        "August",
        "September",
        "October",
        "November",
        "December"
      ];

      print("DATE BORN");
      Response resDateBorn = await get(Uri.parse(
          "https://en.wikipedia.org/w/api.php?action=query&prop=revisions&rvprop=content&format=json&titles=${actorName.replaceAll(" ", "%20")}&rvsection=0"));
      var dateBorn = "";
      if (resDateBorn.statusCode == 200) {
        var body = jsonDecode(resDateBorn.body);
        var ls = const LineSplitter();
        try {
          var remove = ls
              .convert(body["query"]["pages"][body["query"]["pages"].keys.first]
                      ["revisions"]
                  .first["*"])
              .where((element) => element.toLowerCase().contains("birth_date"))
              .last
              .split("}}")
              .first
              .split("{{")
              .last
              .split("|");
          var i = remove.indexWhere(
              (element) => element.contains("df=") || element.contains("mf="));
          if (i != -1) remove.removeAt(i);
          var take = remove.reversed.take(3).toList();
          dateBorn =
              "${monthNames[int.parse(take[1]) - 1]} ${take[0]}, ${take[2]}";
        } catch (e) {
          var where = ls
              .convert(body["query"]["pages"][body["query"]["pages"].keys.first]
                      ["revisions"]
                  .first["*"])
              .where((element) => element.toLowerCase().contains("birth_date"));
          if (where.isEmpty) {
            resDateBorn = await get(Uri.parse(
                "https://en.wikipedia.org/w/api.php?action=query&prop=revisions&rvprop=content&format=json&titles=${actorName.replaceAll(" ", "%20")}%20(actor)&rvsection=0"));
            body = jsonDecode(resDateBorn.body);
            try {
              var remove = ls
                  .convert(body["query"]["pages"]
                          [body["query"]["pages"].keys.first]["revisions"]
                      .first["*"])
                  .where(
                      (element) => element.toLowerCase().contains("birth_date"))
                  .last
                  .split("}}")
                  .first
                  .split("{{")
                  .last
                  .split("|");
              var i = remove.indexWhere((element) =>
                  element.contains("df=") || element.contains("mf="));
              if (i != -1) remove.removeAt(i);
              var take = remove.reversed.take(3).toList();
              dateBorn =
                  "${monthNames[int.parse(take[1]) - 1]} ${take[0]}, ${take[2]}";
            } catch (e) {}
          }
        }
        // print(remove.reversed.take(3));
      } else {
        throw "Unable to retrieve info.";
      }
      // print(actorName + " " + dateBorn);

      print("DATE DIED");
      Response resDateDied = await get(Uri.parse(
          "https://en.wikipedia.org/w/api.php?action=query&prop=revisions&rvprop=content&format=json&titles=${actorName.replaceAll(" ", "%20")}&rvsection=0"));
      var dateDied = "";
      if (resDateDied.statusCode == 200) {
        var body = jsonDecode(resDateDied.body);
        var ls = const LineSplitter();
        try {
          var where = ls
              .convert(body["query"]["pages"][body["query"]["pages"].keys.first]
                      ["revisions"]
                  .first["*"])
              .where((element) => element.toLowerCase().contains("death_date"));
          if (where.isNotEmpty) {
            var remove =
                where.last.split("}}").first.split("{{").last.split("|");
            var i = remove.indexWhere((element) =>
                element.contains("df=") || element.contains("mf="));
            if (i != -1) remove.removeAt(i);
            var take = remove.reversed.skip(3).take(3).toList();
            dateDied =
                "${monthNames[int.parse(take[1]) - 1]} ${take[0]}, ${take[2]}";
          }
        } catch (e) {
          var where = ls
              .convert(body["query"]["pages"][body["query"]["pages"].keys.first]
                      ["revisions"]
                  .first["*"])
              .where((element) => element.toLowerCase().contains("death_date"));
          if (where.isEmpty) {
            resDateDied = await get(Uri.parse(
                "https://en.wikipedia.org/w/api.php?action=query&prop=revisions&rvprop=content&format=json&titles=${actorName.replaceAll(" ", "%20")}%20(actor)&rvsection=0"));
            body = jsonDecode(resDateDied.body);
            try {
              var remove = ls
                  .convert(body["query"]["pages"]
                          [body["query"]["pages"].keys.first]["revisions"]
                      .first["*"])
                  .where(
                      (element) => element.toLowerCase().contains("death_date"))
                  .last
                  .split("}}")
                  .first
                  .split("{{")
                  .last
                  .split("|");
              var i = remove.indexWhere((element) =>
                  element.contains("df=") || element.contains("mf="));
              if (i != -1) remove.removeAt(i);
              var take = remove.reversed.skip(3).take(3).toList();
              dateDied =
                  "${monthNames[int.parse(take[1]) - 1]} ${take[0]}, ${take[2]}";
            } catch (e) {}
          }
        }
        // print(remove.reversed.take(3));
      } else {
        throw "Unable to retrieve info.";
      }
      // print(actorName + " " + dateDied);
      var awardWins = 0;
      var awardNoms = 0;

      print("AWARDS");
      if (!(actorName == "Ayrton Senna" ||
          actorName == "Alain Prost" ||
          actorName == "Nigel Mansell")) {
        Response resAwards = await get(Uri.parse(
            "https://en.wikipedia.org/w/api.php?action=parse&format=json&page=List_of_awards_and_nominations_received_by_${actorName.replaceAll(" ", "_")}&prop=wikitext&formatversion=2"));

        if (resAwards.statusCode == 200) {
          var body = jsonDecode(resAwards.body);
          var ls = const LineSplitter();
          try {
            var convert = ls.convert(body["parse"]["wikitext"]);
            var wins = convert.where((element) => element.contains("{{won|"));
            var noms = convert.where((element) => element.contains("{{nom|"));
            if (noms.isEmpty) {
              var wins =
                  convert.where((element) => element.contains("wins ")).first;
              var noms = convert
                  .where((element) => element.contains("nominations "))
                  .first;
              awardWins = int.parse(wins.split(" = ").last.split(" <").first);
              awardNoms = int.parse(noms.split(" = ").last.split(" <").first);
            } else {
              if (wins.last.contains("colspan") || wins.last.contains("'''")) {
                awardWins = int.parse(wins
                    .firstWhere((element) => element.contains("colspan"),
                        orElse: () => wins.last)
                    .trim()
                    .split("}}")
                    .first
                    .split("{{")
                    .last
                    .split("|")
                    .last
                    .replaceAll("'''", ""));
                awardNoms = int.parse(noms
                    .firstWhere((element) => element.contains("colspan"),
                        orElse: () => noms.last)
                    .trim()
                    .split("}}")
                    .first
                    .split("{{")
                    .last
                    .split("|")
                    .last
                    .replaceAll("'''", ""));
              } else {
                for (var item in wins) {
                  var number = item
                      .trim()
                      .split("}}")
                      .first
                      .split("{{")
                      .last
                      .split("|")
                      .last;
                  // print(number);
                  if (int.tryParse(number) != null) {
                    awardWins += int.parse(number);
                  }
                }
                for (var item in noms) {
                  var number = item
                      .trim()
                      .split("}}")
                      .first
                      .split("{{")
                      .last
                      .split("|")
                      .last;
                  // print(number);
                  if (int.tryParse(number) != null) {
                    awardNoms += int.parse(number);
                  }
                }
              }
            }
          } catch (e) {
            // print(actorName + "9999");
            Response resSections = await get(Uri.parse(
                "https://en.wikipedia.org/w/api.php?action=parse&format=json&page=${actorName.replaceAll(" ", "_")}&prop=sections&disabletoc=1"));
            if (resSections.statusCode == 200) {
              body = jsonDecode(resSections.body);
              if (body["parse"]["sections"].isEmpty) {
                resSections = await get(Uri.parse(
                    "https://en.wikipedia.org/w/api.php?action=parse&format=json&page=${actorName.replaceAll(" ", "_")}_(actor)&prop=sections&disabletoc=1"));
                if (resSections.statusCode == 200) {
                  body = jsonDecode(resSections.body);
                  try {
                    var sections = body["parse"]["sections"];
                    for (var element in sections) {
                      if (element["line"].toLowerCase().contains("awards") ||
                          element["line"].toLowerCase().contains("accolades")) {
                        // print(element["index"]);
                        Response resMainPage = await get(Uri.parse(
                            "https://en.wikipedia.org/w/api.php?action=parse&format=json&page=${actorName.replaceAll(" ", "_")}_(actor)&prop=text&section=${element["index"]}&disabletoc=1&prop=wikitext"));
                        if (resMainPage.statusCode == 200) {
                          var awards = jsonDecode(resMainPage.body);
                          awardWins = "{{won}}"
                                  .allMatches(awards["parse"]["wikitext"]
                                      [awards["parse"]["wikitext"].keys.first])
                                  .length +
                              "{{win}}"
                                  .allMatches(awards["parse"]["wikitext"]
                                      [awards["parse"]["wikitext"].keys.first])
                                  .length +
                              "{{WON}}"
                                  .allMatches(awards["parse"]["wikitext"]
                                      [awards["parse"]["wikitext"].keys.first])
                                  .length;
                          awardNoms = awardWins +
                              "{{nom}}"
                                  .allMatches(awards["parse"]["wikitext"]
                                      [awards["parse"]["wikitext"].keys.first])
                                  .length +
                              "{{Nominated}}"
                                  .allMatches(awards["parse"]["wikitext"]
                                      [awards["parse"]["wikitext"].keys.first])
                                  .length;
                        }
                        break;
                      }
                    }
                    // element["line"].toLowerCase().contains("awards"))
                  } catch (e) {}
                }
              } else {
                var sections = body["parse"]["sections"];
                for (var element in sections) {
                  if (element["line"].toLowerCase().contains("awards") ||
                      element["line"].toLowerCase().contains("accolades")) {
                    Response resMainPage = await get(Uri.parse(
                        "https://en.wikipedia.org/w/api.php?action=parse&format=json&page=${actorName.replaceAll(" ", "_")}&prop=text&section=${element["index"]}&disabletoc=1&prop=wikitext"));
                    if (resMainPage.statusCode == 200) {
                      var awards = jsonDecode(resMainPage.body);
                      awardWins = "{{won}}"
                              .allMatches(awards["parse"]["wikitext"]
                                  [awards["parse"]["wikitext"].keys.first])
                              .length +
                          "{{win}}"
                              .allMatches(awards["parse"]["wikitext"]
                                  [awards["parse"]["wikitext"].keys.first])
                              .length +
                          "{{WON}}"
                              .allMatches(awards["parse"]["wikitext"]
                                  [awards["parse"]["wikitext"].keys.first])
                              .length;
                      awardNoms = awardWins +
                          "{{nom}}"
                              .allMatches(awards["parse"]["wikitext"]
                                  [awards["parse"]["wikitext"].keys.first])
                              .length +
                          "{{Nominated}}"
                              .allMatches(awards["parse"]["wikitext"]
                                  [awards["parse"]["wikitext"].keys.first])
                              .length;
                    }
                    break;
                  }
                }
              }
            }
          }
        } else {
          // print(actorName + "5555");
        }
        // print(actorName + " " + awardWins.toString());
        // print(actorName + " " + awardNoms.toString());
      }

      print("PHOTO");
      var photo = "";
      Response resPhoto = await get(Uri.parse(
          "https://en.wikipedia.org/w/api.php?action=query&titles=${actorName.replaceAll(" ", "%20")}&prop=pageimages&format=json&pithumbsize=2000"));
      if (resPhoto.statusCode == 200) {
        var body = jsonDecode(resPhoto.body);
        try {
          photo = body["query"]["pages"][body["query"]["pages"].keys.first]
              ["thumbnail"]["source"];
        } catch (e) {
          resPhoto = await get(Uri.parse(
              "https://en.wikipedia.org/w/api.php?action=query&titles=${actorName.replaceAll(" ", "%20")}%20(actor)&prop=pageimages&format=json&pithumbsize=2000"));
          if (resPhoto.statusCode == 200) {
            body = jsonDecode(resPhoto.body);
            try {
              photo = body["query"]["pages"][body["query"]["pages"].keys.first]
                  ["thumbnail"]["source"];
            } catch (e) {}
          }
        }
      } else {
        print("ERROR");
      }
      if (people.docs.any((element) => element["name"] == actorName)) {
        var person =
            people.docs.firstWhere((element) => element["name"] == actorName);
        if (!person["type"].contains(type)) {
          collection
              .doc(person.id)
              .update({"type": person["type"] + "," + type});
        }
        return person.id;
      }
      // print({
      //   "awardNoms": awardNoms,
      //   "awardWins": awardWins,
      //   "born": dateBorn,
      //   "died": dateDied,
      //   "name": actorName,
      //   "photo": photo,
      //   "summary": summary,
      //   "type": type
      // });
      // return "";
      return (await collection.add({
        "awardNoms": awardNoms,
        "awardWins": awardWins,
        "born": dateBorn,
        "died": dateDied,
        "name": actorName,
        "photo": photo,
        "summary": summary,
        "type": type
      }))
          .id;
    } catch (e) {
      return (await collection.add({
        "awardNoms": 0,
        "awardWins": 0,
        "born": "",
        "died": "",
        "name": actorName,
        "photo": "",
        "summary": "",
        "type": type
      }))
          .id;
    }
  }
}
