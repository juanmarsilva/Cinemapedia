import 'package:cinemapedia/infrastructure/models/moviedb/movie_details.dart';
import 'package:dio/dio.dart';
import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/infrastructure/mappers/movie_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/moviedb_response.dart';

class MovieDbDatasource extends MoviesDatasource {

    final dio = Dio(BaseOptions(
        baseUrl: 'https://api.themoviedb.org/3',
        queryParameters: {
            'api_key': Environment.movieDbKey,
            'language': 'es-ES'
        }
    ));

    /*
      * custom get para invocar por url.
    */
    Future<Response<dynamic>> customGet(String url, int page) async {
        return await dio.get(url, queryParameters: {
            'page': page
        });
    }

    /*
      * Convierte la respuesta JSON del servicio get en un listado de peliculas a devolver.
    */
    List<Movie> _jsonToMovies( Map<String, dynamic> json ) {

        final movieDbResponse = MovieDbResponse.fromJson( json );

        /*
          * De esta manera evitamos renderizar o tener en el listado peliculas cuyo poster no exista. Es como filtrarlas. Para evitar que la aplicacion rompa en otro punto.
        */
        final List<Movie> movies = movieDbResponse.results
        .where((moviedb) => moviedb.posterPath != 'no-poster')
        .map(
            (moviedb) => MovieMapper.movieDBToEntity(moviedb)
        )
        .toList();

        return movies;
    }

    @override
    Future<List<Movie>> getNowPlaying({ int page = 1 }) async {
        final response = await customGet('/movie/now_playing', page);

        return _jsonToMovies( response.data );
    }
    
    @override
    Future<List<Movie>> getPopular({ int page = 1 }) async {
        final response = await customGet('/movie/popular', page);

        return _jsonToMovies( response.data );
       
    }
    
    @override
    Future<List<Movie>> getTopRated({int page = 1}) async {
        final response = await customGet('/movie/top_rated', page);

        return _jsonToMovies( response.data );
    }
    
    @override
    Future<List<Movie>> getUpcoming({int page = 1}) async {
        final response = await customGet('/movie/upcoming', page);

        return _jsonToMovies( response.data );
    }
    
    @override
    Future<Movie> getMovieById(String id) async {
        final response = await dio.get('/movie/$id');

        if( response.statusCode != 200 ) throw Exception('Movie with id: $id not found');

        final movieDB = MovieDetails.fromJson( response.data );

        final Movie movie = MovieMapper.movieDetailsToEntity( movieDB );

        return movie;

    }

}