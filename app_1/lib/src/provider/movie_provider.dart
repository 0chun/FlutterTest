import 'package:flutter/material.dart';
import 'package:app_1/src/model/movie.dart';
import 'package:app_1/src/repository/movie_repository.dart';

class MovieProvider extends ChangeNotifier {
  MovieRepository _movieRepository = MovieRepository();
  List<Movie> _movies = [];
  List<Movie> get movies => _movies;

  loadMovies() async {
    List<Movie> ListMovies = await _movieRepository.loadMovies();
    _movies = ListMovies;
    notifyListeners();
  }
}
