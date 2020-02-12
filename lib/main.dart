import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    home: SplashScreen(),
    debugShowCheckedModeBanner: false,
    theme:ThemeData.dark(),
  ));
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<Timer> loadData() async {
    return new Timer(Duration(seconds: 10), onDoneLoading);
  }
  onDoneLoading() async {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffffff),
        body:Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/success.png"),
              fit: BoxFit.fill,
            ),
          ),
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Ask\nBelieve\nReceeive",
                    style: TextStyle(
                      fontSize: 40.0,
                      color:Colors.white,
                      fontWeight:FontWeight.w800,
                      fontFamily: "Cursive",
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);


  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Quotes of the day"),
          centerTitle: true,
        ),
        body:Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/cycle.png"),
              fit: BoxFit.fill,
            ),
          ),
          child:Center(
            child: FutureBuilder<Quote>(
              future: getQuote(), //sets the getQuote method as the expected Future
              builder: (context, snapshot) {
                if (snapshot.hasData) { //checks if the response returns valid data
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(snapshot.data.quote,
                            style:TextStyle(
                              color: Colors.white.withOpacity(1.0),
                              fontSize: 20,
                              fontWeight:FontWeight.w800,
                            )), //displays the quote

                        SizedBox(
                          height: 10.0,
                        ),
                        Text(" - ${snapshot.data.author}",
                          style: TextStyle(color: Colors.white60.withOpacity(1.0)),), //displays the quote's author
                      ],
                    ),
                  );
                } else if (snapshot.hasError) { //checks if the response throws an error
                  return Text("${snapshot.error}");
                }
                return CircularProgressIndicator();
              },
            ),
          ),

        ));
  }
}

Future<Quote> getQuote() async {
  String url = 'https://quotes.rest/qod.json';
  final response =
  await http.get(url, headers: {"Accept": "application/json"});


  if (response.statusCode == 200) {
    return Quote.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load Quote');
  }
}

class Quote {
  final String author;
  final String quote;

  Quote({this.author, this.quote});

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
        author: json['contents']['quotes'][0]['author'],
        quote: json['contents']['quotes'][0]['quote']);
  }
}
