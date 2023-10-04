import 'package:cinemapedia/domain/entities/movie.dart';

abstract class LocalStorageDatasource {
    Future<void> toogleFavorite( Movie movie );

    Future<bool> isMovieInFavorites( int movieId );

    Future<List<Movie>> loadMovies({ int limit = 10, offset = 0 });
}