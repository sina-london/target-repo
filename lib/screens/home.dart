// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Featured
            Text(
              "Featured",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Image.network(
                            "https://imgs.search.brave.com/YXiVzusfQv7LN7VONe6DXRIJKz6TZoFDsZmJxI3w2OU/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9zdGF0/aWMxLnNyY2RuLmNv/bS93b3JkcHJlc3Mv/d3AtY29udGVudC91/cGxvYWRzLzIwMjMv/MDkvanVqdXRzdS1r/YWlzZW4tYW5pbWUt/cG9zdGVyLmpwZw",
                            height: MediaQuery.of(context).size.width * 0.8,
                          ),
                        ),
                        Text(
                          "Jujutsu Kaisen",
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Image.network(
                            "https://imgs.search.brave.com/ymtCj8B7ht50NTbyGV0RdhI76C-TOaImxq70xMaUPT8/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9zdGF0/aWMwLmdhbWVyYW50/aW1hZ2VzLmNvbS93/b3JkcHJlc3Mvd3At/Y29udGVudC91cGxv/YWRzLzIwMjMvMDkv/b25lLXBpZWNlLTku/anBn",
                            height: MediaQuery.of(context).size.width * 0.8,
                          ),
                        ),
                        Text(
                          "Jujutsu Kaisen",
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Recent Episodes",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          alignment: Alignment.topRight,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: Image.network(
                                "https://imgs.search.brave.com/2g47T5mHsUG8xETMFtKN9jPVlOb3BDPwnXzxFrHyNwE/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9tLm1l/ZGlhLWFtYXpvbi5j/b20vaW1hZ2VzL00v/TVY1Qk1tTTBPR1Uy/TmpndFltRTVaUzAw/TUdVM0xXRmtZbVF0/T0Raa01UaGhNREE0/WlRkbVhrRXlYa0Zx/Y0djQC5qcGc",
                                height: MediaQuery.of(context).size.width * 0.4,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  left: 8.0, right: 5.0, top: 5.0, bottom: 8.0),
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(15.0))),
                              child: Text(
                                "1",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          alignment: Alignment.topRight,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: Image.network(
                                "https://imgs.search.brave.com/JDKkfycpxE_nNzjJkDUWlvpL_KrxXdkfFZSI-SSKv_c/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly93YWxs/cGFwZXJzLmNvbS9p/bWFnZXMvZmVhdHVy/ZWQvcG9rZW1vbi12/YTYxMzllZzVjc3pu/em13LmpwZw",
                                height: MediaQuery.of(context).size.width * 0.4,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  left: 8.0, right: 5.0, top: 5.0, bottom: 8.0),
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(15.0))),
                              child: Text(
                                "2",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          alignment: Alignment.topRight,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: Image.network(
                                "https://imgs.search.brave.com/2g47T5mHsUG8xETMFtKN9jPVlOb3BDPwnXzxFrHyNwE/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9tLm1l/ZGlhLWFtYXpvbi5j/b20vaW1hZ2VzL00v/TVY1Qk1tTTBPR1Uy/TmpndFltRTVaUzAw/TUdVM0xXRmtZbVF0/T0Raa01UaGhNREE0/WlRkbVhrRXlYa0Zx/Y0djQC5qcGc",
                                height: MediaQuery.of(context).size.width * 0.4,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  left: 8.0, right: 5.0, top: 5.0, bottom: 8.0),
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(15.0))),
                              child: Text(
                                "3",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
