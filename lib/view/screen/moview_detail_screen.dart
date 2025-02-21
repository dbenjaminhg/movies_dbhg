import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movies_dbhg/model/constantas.dart';
import 'package:movies_dbhg/model/movie.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MovieDetailScreen extends StatelessWidget {
  static const routeName = '/movieDetails';

  final Movie movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(movie.title)),
      body: Column(
        children: [
          CachedNetworkImage(
            imageUrl: '${Constants.imageBaseUrl}${movie.posterPath}',
            width: 180,
            height: 270,
            fit: BoxFit.cover,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          Text(
            AppLocalizations.of(context)!.release_date +
                DateFormat('dd-MMM-yyyy').format(movie.releaseDate),
          ),
          Text(movie.overview),
        ],
      ),
    );
  }
}
