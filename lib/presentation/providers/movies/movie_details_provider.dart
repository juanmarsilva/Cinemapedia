import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/domain/entities/movie.dart';

final movieDetailProvider = StateNotifierProvider<MovieMapNotifier, Map<String, Movie>>((ref) => 
    MovieMapNotifier(
        getMovie: ref.watch( movieRepositoryProvider ).getMovieById
    )
);



/*
    {
        '505642': Movie,
        '505643': Movie,
        '505644': Movie,
        '505645': Movie,
        '505646': Movie,
    }
*/
typedef GetMovieCallback = Future<Movie>Function(String movieId); 

class MovieMapNotifier extends StateNotifier<Map<String, Movie>> {

    final GetMovieCallback getMovie;
    
    MovieMapNotifier({ required this.getMovie }): super({});

    Future<void> loadMovie( String movieId ) async {
        if( state[movieId] != null ) return;

        final movie = await getMovie( movieId );

        state = { ...state, movieId: movie };
    }


}