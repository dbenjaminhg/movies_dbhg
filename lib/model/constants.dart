class Constants {
  static const String apiKey = '<API_KEY_HERE>';
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';
}

class EndPoints {
  static const String popularMovies =
      '/discover/movie?include_adult=false&include_video=false&language={lan}&page={page}&sort_by=popularity.desc ';
  static const String nowPlayingMovies =
      '/discover/movie?include_adult=false&include_video=false&language={lan}&page={page}&sort_by=popularity.desc&with_release_type=2|3&release_date.gte={min_date}&release_date.lte={max_date}';
}
