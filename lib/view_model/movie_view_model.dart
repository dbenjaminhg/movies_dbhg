import 'package:flutter/foundation.dart';
import 'package:movies_dbhg/model/MovieRepository.dart';
import 'package:movies_dbhg/model/movie.dart';
import 'package:movies_dbhg/model/responses/api_response.dart';

class MovieViewModel with ChangeNotifier {
  ApiResponse _apiResponse = ApiResponse.initial('Empty data');

  Movie? _movie;

  ApiResponse get response {
    return _apiResponse;
  }

  Movie? get movie {
    return _movie;
  }

  /// Call the movie service and gets the data of requested movie data of
  /// an artist.
  Future<void> fetchMovieData() async {
    if (_apiResponse.status == Status.INITIAL) {
      _apiResponse = ApiResponse.loading('Fetching artist data');
      notifyListeners();
      try {
        List<Movie> movieList = await MovieRepository().fetchMoviesList();
        _apiResponse = ApiResponse.completed(movieList);
      } catch (e) {
        _apiResponse = ApiResponse.error(e.toString());
        if (kDebugMode) {
          print(e);
        }
      }
      notifyListeners();
    }
  }

  void setSelectedMovie(Movie? movie) {
    _movie = movie;
    notifyListeners();
  }
}
