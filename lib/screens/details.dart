// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nekoflow/data/models/details_model.dart';
import 'package:nekoflow/screens/stream.dart';

class Details extends StatefulWidget {
  final String id;
  final String image;
  final String title;

  const Details(
      {super.key, required this.id, required this.image, required this.title});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  static const String baseUrl =
      "https://animaze-swart.vercel.app/anime/gogoanime/info";

  AnimeDetails? info;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final response = await http.get(Uri.parse("$baseUrl/${widget.id}"));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          info = AnimeDetails.fromJson(jsonData);
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Something went wrong';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Something went wrong';
        isLoading = false;
      });
    }
  }

  Widget _buildHeaderImage() {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        Image.network(
          widget.image,
          width: MediaQuery.of(context).size.width,
          height: 300,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Center(
            child: Icon(Icons.error),
          ),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const SizedBox(
              height: 300,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.7),
              ],
            ),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Text(
            widget.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 32,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection() {
    if (info == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow(
            "Genres",
            info!.genres.join(', '),
          ),
          SizedBox(
            height: 8.0,
          ),
          _buildInfoRow("Total Episodes",
              "${info!.episodes.length} | Release Date: ${info!.releaseDate}"),
          SizedBox(
            height: 24.0,
          ),
          _buildSectionTitle("Description"),
          const SizedBox(
            height: 8.0,
          ),
          Text(
            info!.description,
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(
            height: 24.0,
          ),
          _buildSectionTitle("Episodes"),
          const SizedBox(
            height: 16.0,
          ),
          _buildEpisodesList()
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          color: Colors.black,
          fontSize: 15,
          height: 1.5,
        ),
        children: [
          TextSpan(
            text: "$label: ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: value),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    );
  }

  Widget _buildEpisodesList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: info!.episodes.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) => _buildEpisodeRow(info!.episodes[index]),
    );
  }

  Widget _buildEpisodeRow(Episode episode) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        "Episode ${episode.number}",
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      trailing: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Stream(id: episode.id, title: widget.title),
            ),
          );
        },
        child: const Icon(
          Icons.play_arrow,
          size: 35,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: fetchData,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : error != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(error!),
                        const SizedBox(
                          height: 16.0,
                        ),
                        ElevatedButton(
                          onPressed: fetchData,
                          child: const Text('Retry'),
                        )
                      ],
                    ),
                  )
                : ListView(
                    children: [
                      _buildHeaderImage(),
                      _buildInfoSection(),
                    ],
                  ),
      ),
    );
  }
}
