import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Quote> fetchQuote() async {
  final response = await http.get('https://api.iextrading.com/1.0/stock/AAPL/delayed-quote');
  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    return Quote.fromJson(json.decode(response.body));
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

Future<Movie> fetchMovie() async {
  final response = await http.get('https://ghibliapi.herokuapp.com/films/2baf70d1-42bb-4437-b551-e5fed5a87abe');
  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    return Movie.fromJson(json.decode(response.body));
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

class Movie {
  final String id;
  final String title;
  final String description;
  final String director;
  final String releasedate;
  final String rtscore;
  final List<dynamic> people;
  final List<dynamic> species;
  final List<dynamic> locations;
  final List<dynamic> vehicles;
  final String url;

  Movie({this.id, this.title, this.description, this.director, this.releasedate, this.rtscore, this.people, this.species, this.locations, this.vehicles, this.url});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      director: json['director'],
      releasedate: json['release_date'],
      rtscore: json['rt_score'],
      people: json['people'],
      species: json['species'],
      locations: json['locations'],
      vehicles: json['vehicles'],
      url: json['url']
    );
  }
}


class Quote {
  final String symbol;
  final double delayedPrice;
  final double high;
  final double low;
  final int delayedSize;
  final int delayedPriceTime;
  final int processedTime;

  Quote({this.symbol, this.delayedPrice, this.high, this.low, this.delayedSize, this.delayedPriceTime, this.processedTime});

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      symbol: json['symbol'],
      delayedPrice: json['delayedPrice'],
      high: json['high'],
      low: json['low'],
      delayedSize: json['delayedSize'],
      delayedPriceTime: json['delayedPriceTime'],
      processedTime: json['processedTime']
    );
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stocks',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<Movie>(
            future: fetchMovie(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data.title + ': ' + snapshot.data.description);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}