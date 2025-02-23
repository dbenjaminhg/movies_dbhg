import 'package:flutter/material.dart';
import 'package:movies_dbhg/model/movie.dart';
import 'package:movies_dbhg/model/responses/api_response.dart';
import 'package:movies_dbhg/view/screen/moview_detail_screen.dart';
import 'package:movies_dbhg/view/screen/settings_screen.dart';
import 'package:movies_dbhg/view/widgets/movie_list.dart';
import 'package:movies_dbhg/view_model/movie_view_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MovieScreen extends StatefulWidget {
  const MovieScreen({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _MovieScreenState createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  final SearchController controller = SearchController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 5), () {
      // ignore: use_build_context_synchronously
      Provider.of<MovieViewModel>(context, listen: false).fetchMovieData();
    });
  }

  Widget getMovieWidget(BuildContext context, ApiResponse apiResponse) {
    List<Movie>? movieList = apiResponse.data as List<Movie>?;
    if (movieList != null) {
      switch (apiResponse.status) {
        case Status.LOADING:
          return Center(child: CircularProgressIndicator());
        case Status.COMPLETED:
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SearchAnchor(
                searchController: controller,
                builder: (BuildContext context, SearchController controller) {
                  return SearchBar(
                    controller: controller,
                    padding: const WidgetStatePropertyAll<EdgeInsets>(
                      EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                    onTap: () {
                      controller.openView();
                    },
                    onChanged: (_) {
                      controller.openView();
                    },
                    leading: const Icon(Icons.search),
                  );
                },
                suggestionsBuilder: (
                  BuildContext context,
                  SearchController controller,
                ) {
                  List<Movie>? filteredList =
                      movieList
                          .where(
                            (Movie movie) => movie.title
                                .toLowerCase()
                                .startsWith(controller.text.toLowerCase()),
                          )
                          .toList();

                  return List<ListTile>.generate(filteredList.length, (
                    int index,
                  ) {
                    final String item = filteredList[index].title;
                    return ListTile(
                      title: Text(item),
                      onTap: () {
                        setState(() {
                          controller.closeView(item);
                          controller.text = '';
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => MovieDetailScreen(
                                  movie: filteredList[index],
                                ),
                          ),
                        );
                      },
                    );
                  });
                },
              ),

              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: MovieList(movies: movieList),
                ),
              ),
            ],
          );
        case Status.ERROR:
          return Center(child: Text(AppLocalizations.of(context)!.retry));
        case Status.INITIAL:
          return Center(child: CircularProgressIndicator());
      }
    } else {
      Future.delayed(Duration.zero, () {
        Provider.of<MovieViewModel>(context, listen: false).fetchMovieData();
      });
      return Center(child: CircularProgressIndicator());
    }
  }

  @override
  Widget build(BuildContext context) {
    ApiResponse apiResponse = Provider.of<MovieViewModel>(context).response;

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.movies)),
      body: getMovieWidget(context, apiResponse),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 19, 14, 120),
        tooltip: AppLocalizations.of(context)!.settings,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SettingsScreen()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}
