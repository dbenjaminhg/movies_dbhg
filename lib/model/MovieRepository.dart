import 'package:movies_dbhg/model/constantas.dart';
import 'package:movies_dbhg/model/movie.dart';
import 'package:movies_dbhg/model/services/app_base_service.dart';
import 'package:movies_dbhg/model/services/movie_service.dart';

class MovieRepository {
  // ignore: prefer_final_fields
  AppBaseService _movieService = MovieService();

  Future<List<Movie>> fetchMoviesList() async {
    dynamic response = await _movieService.getResponse(
      '${Constants.baseUrl}/movie/popular?api_key=${Constants.apiKey}',
    );
    final jsonData = response['results'] as List;
    List<Movie> movieList =
        jsonData.map((jsonElement) => Movie.fromJson(jsonElement)).toList();
    return movieList;
  }
}
