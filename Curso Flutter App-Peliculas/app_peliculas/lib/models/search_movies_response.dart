// To parse this JSON data, do
//
//     final searchMoviesResponse = searchMoviesResponseFromMap(jsonString);

import 'dart:convert';

import 'package:app_peliculas/models/models.dart';

SearchMoviesResponse searchMoviesResponseFromMap(String str) => SearchMoviesResponse.fromMap(json.decode(str));

String searchMoviesResponseToMap(SearchMoviesResponse data) => json.encode(data.toMap());

class SearchMoviesResponse {
    SearchMoviesResponse({
        required this.page,
        required this.results,
        required this.totalPages,
        required this.totalResults,
    });

    int page;
    List<Movies> results;
    int totalPages;
    int totalResults;

    factory SearchMoviesResponse.fromMap(Map<String, dynamic> json) => SearchMoviesResponse(
        page: json["page"],
        results: List<Movies>.from(json["results"].map((x) => Movies.fromMap(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
    );

    Map<String, dynamic> toMap() => {
        "page": page,
        "results": List<dynamic>.from(results.map((x) => x.toMap())),
        "total_pages": totalPages,
        "total_results": totalResults,
    };
}

