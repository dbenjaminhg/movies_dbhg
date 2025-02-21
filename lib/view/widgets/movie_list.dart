import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:movies_dbhg/model/constantas.dart';
import 'package:movies_dbhg/model/movie.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:movies_dbhg/view/screen/moview_detail_screen.dart';

class MovieList extends StatelessWidget {
  final List<Movie> movies;

  const MovieList({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 1, //movies.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            Text(AppLocalizations.of(context)!.top_movies),
            CarouselSlider(
              options: CarouselOptions(
                height: 450.0,
                aspectRatio: 16 / 9,
                viewportFraction: 0.8,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                enlargeFactor: 0.3,
                onPageChanged: (index, reason) {
                  if (kDebugMode) {
                    print(index);
                  }
                },
                scrollDirection: Axis.horizontal,
              ),
              items:
                  movies.map((movie) {
                    return Builder(
                      builder: (BuildContext context) {
                        return GestureDetector(
                          onTap: () {
                            if (kDebugMode) {
                              print(movie.title);
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        MovieDetailScreen(movie: movie),
                              ),
                            );
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(horizontal: 5.0),

                            decoration: BoxDecoration(
                              color: const Color.fromARGB(0, 230, 230, 230),
                            ),
                            child: Column(
                              children: [
                                CachedNetworkImage(
                                  imageUrl:
                                      '${Constants.imageBaseUrl}${movie.posterPath}',
                                  width: 180,
                                  height: 270,
                                  fit: BoxFit.cover,
                                  placeholder:
                                      (context, url) =>
                                          CircularProgressIndicator(),
                                  errorWidget:
                                      (context, url, error) =>
                                          Icon(Icons.error),
                                ),
                                Text(movie.title),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
            ),
          ],
        );
      },
    );
  }
}
