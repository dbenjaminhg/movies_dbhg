import 'package:intl/intl.dart';
import 'package:movies_dbhg/model/constants.dart';
import 'package:movies_dbhg/model/movie.dart';
import 'package:movies_dbhg/model/services/app_base_service.dart';
import 'package:movies_dbhg/model/services/movie_service.dart';

// Class Repository to fetch the data from the api
class MovieRepository {
  // ignore: prefer_final_fields
  AppBaseService _movieService = MovieService();

  // Methods to fetch the list of popular movies
  Future<List<Movie>> fetchPopularMoviesList(String lan) async {
    String url =
        '${Constants.baseUrl}${EndPoints.popularMovies}&api_key=${Constants.apiKey}';
    url = url.replaceAll("{page}", "1").replaceAll("{lan}", getLanCode(lan));
    dynamic response = await _movieService.getResponse(url);
    final jsonData = response['results'] as List;
    List<Movie> movieList =
        jsonData.map((jsonElement) => Movie.fromJson(jsonElement)).toList();
    return movieList;
  }

  // Method to fetch the list of movies playing now
  Future<List<Movie>> fetchPlayNowMoviesList(int page, String lan) async {
    var now = DateTime.now();
    var minDateT = DateTime(now.year, now.month, now.day - 7);
    var formatter = DateFormat('yyyy-MM-dd');
    String maxDate = formatter.format(now);
    String minDate = formatter.format(minDateT);

    String url =
        '${Constants.baseUrl}${EndPoints.nowPlayingMovies}&api_key=${Constants.apiKey}';
    url = url
        .replaceAll("{page}", page.toString())
        .replaceAll("{lan}", getLanCode(lan))
        .replaceAll("{min_date}", getLanCode(minDate))
        .replaceAll("{max_date}", getLanCode(maxDate));

    dynamic response = await _movieService.getResponse(url);
    final jsonData = response['results'] as List;
    List<Movie> movieList =
        jsonData.map((jsonElement) => Movie.fromJson(jsonElement)).toList();
    return movieList;
  }

  // Method to return the language code
  static String getLanCode(String lan) {
    String languageCode = 'en-US';
    if (lan == 'en') {
      languageCode = 'en-US';
    } else if (lan == 'es') {
      languageCode = 'es-MX';
    }
    return languageCode;
  }
}
