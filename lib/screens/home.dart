// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:nekoflow/screens/stream.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Function to fetch anime data from API
  var top_airing;
  var popular;
  Future<void> fetchData() async {
    const BASE_URL = "https://animaze-swart.vercel.app/anime/gogoanime";
    print("Fetching data from API");

    try {
      final top_airing_response = await http.get(Uri.parse("$BASE_URL/movies"));
      final popular_response = await http.get(Uri.parse("$BASE_URL/popular"));

      if (top_airing_response.statusCode == 200 &&
          popular_response.statusCode == 200) {
        var top_airing_decoded = json.decode(top_airing_response.body);
        var popular_decoded = json.decode(popular_response.body);
        setState(() {
          top_airing = top_airing_decoded['results'];
          popular = popular_decoded['results'];
        });
      } else {
        // Todo: Say nothing found
      }
    } catch (error) {
      // Todo: Something Went Wrong
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData(); // Automatically fetch data when the screen is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: ListView(
          children: [
            // Featured
            Text(
              "Featured",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            top_airing != null
                ? SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (var anime in top_airing)
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Stream(
                                            id: anime['id'],
                                          )));
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 20.0),
                              child: SizedBox(
                                // width: MediaQuery.of(context).size.width,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      height: 300,
                                      child: RotatedBox(
                                        quarterTurns: 3,
                                        child: Text(
                                          anime['title'],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(15.0),
                                      child: Image.network(
                                        anime['image'],
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                      ],
                    ),
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  ),
            GestureDetector(
              onTap: () {
                fetchData();
              },
              child: Text(
                "Popular",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            top_airing != null
                ? SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (var anime in popular)
                          Container(
                            margin: EdgeInsets.only(right: 10.0),
                            child: Stack(
                              children: [
                                SizedBox(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15.0),
                                        bottomLeft: Radius.circular(
                                          15.0,
                                        ),
                                        bottomRight: Radius.circular(
                                          15.0,
                                        )),
                                    child: Image.network(
                                      anime['image'],
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.5,
                                      fit: BoxFit
                                          .cover, // Ensures the image covers the area properly
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Container(
                                    padding:
                                        EdgeInsets.only(bottom: 5, left: 5),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(15.0)),
                                    ),
                                    child: Text(
                                      anime['releaseDate'],
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  ),
            Spacer()
          ],
        ),
      ),
    );
  }
}
