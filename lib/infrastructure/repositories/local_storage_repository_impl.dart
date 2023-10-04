import 'package:cinemapedia/domain/domain.dart';

class LocalStorageRepositoryImpl extends LocalStorageRepository {

    final LocalStorageDatasource datasource;

    LocalStorageRepositoryImpl(this.datasource);

    @override
    Future<bool> isMovieInFavorites(int movieId) {
        return datasource.isMovieInFavorites(movieId);
    }

    @override
    Future<List<Movie>> loadMovies({ int limit = 10, offset = 0 }) {
        return datasource.loadMovies(limit: limit, offset: offset);
    }

    @override
    Future<void> toogleFavorite(Movie movie) {
        return datasource.toogleFavorite(movie);
    }

}