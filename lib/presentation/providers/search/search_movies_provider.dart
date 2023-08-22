import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final searchQueryProvider = StateProvider<String>((ref) => '');


/*
  * Esto nos permite recargar las peliculas que habiamos buscado previamente en el buscador.
*/
final searchedMoviesProvider = StateNotifierProvider<SearchedMoviesNotifier, List<Movie>>((ref) {
    return SearchedMoviesNotifier(
        searchMovies: ref.read( movieRepositoryProvider ).searchMovies, 
        ref: ref
    );
});


typedef SearchedMoviesCallback = Future<List<Movie>> Function(String query);

class SearchedMoviesNotifier extends StateNotifier<List<Movie>> {

    final SearchedMoviesCallback searchMovies;
    final Ref ref;

    SearchedMoviesNotifier({
        required this.searchMovies,
        required this.ref
    }): super([]);

    Future<List<Movie>> searchMoviesByQuery( String query ) async {
        
        final List<Movie> movies = await searchMovies(query);
        ref.read( searchQueryProvider.notifier ).update((state) => query);
        
        state = movies;

        return movies;
    }

}