import 'package:isar/isar.dart';

import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/datasources/local_storage_datasource.dart';
import 'package:path_provider/path_provider.dart';


class IsarDatasource extends LocalStorageDatasource {

    late Future<Isar> db;

    IsarDatasource() {
        db = openDB();
    }

    //* Funcion para abrir la base de datos, la tengamos o no.
    Future<Isar> openDB() async {
        if( Isar.instanceNames.isEmpty ) {
            final dir = await getApplicationDocumentsDirectory();

            return await Isar.open(
                [ MovieSchema ],
                inspector: true,
                directory: dir.path,
            );
        }
        return Future.value(Isar.getInstance());
    }

    //* Metodo para verificar si una pelicula esta en favoritos.
    @override
    Future<bool> isMovieInFavorites(int movieId) async {
        final isar = await db;
        
        final Movie? movieInFavorites = await isar.movies
            .filter()
            .idEqualTo(movieId)
            .findFirst();

        return movieInFavorites != null;
    }

    //* Metodo para agregar/eliminar cada pelicula de favoritos.
    @override
    Future<void> toogleFavorite(Movie movie) async {
        final isar = await db;

        final Movie? favoriteMovie = await isar.movies
            .filter()
            .idEqualTo(movie.id)
            .findFirst();

        if( favoriteMovie != null ) {
            isar.writeTxnSync(() => isar.movies.deleteSync( favoriteMovie.isarId! ));
            return;
        }

        isar.writeTxnSync(() => isar.movies.putSync(movie));
    }

    //* Metodo para cargar las peliculas que estan en favoritos.
    @override
    Future<List<Movie>> loadMovies({int limit = 10, offset = 0}) async {
        final isar = await db;

        return isar.movies
          .where()
          .offset(offset)
          .limit(limit)
          .findAll();
    }
}