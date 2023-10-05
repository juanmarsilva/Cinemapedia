import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/domain/domain.dart';
import 'package:cinemapedia/presentation/presentation.dart';

final favoritesMoviesProvider = StateNotifierProvider<StorageMoviesNotifier, Map<int, Movie>>((ref) =>
    StorageMoviesNotifier(localStorageRepository: ref.watch( localStorageRepositoryProvider ))
);


/*
    {
        1234: Movie,
        1645: Movie,
        6523: Movie,
    }
*/
class StorageMoviesNotifier extends StateNotifier<Map<int, Movie>> {

    int page = 0;
    final LocalStorageRepository localStorageRepository;
    
    StorageMoviesNotifier({
        required this.localStorageRepository
    }): super({});

    Future<List<Movie>> loadNextPage() async {
        final movies = await localStorageRepository.loadMovies( offset: page * 10, limit: 20 );

        page++;
        
        final tempMoviesMap = <int, Movie>{};

        for( final movie in movies ) {
            tempMoviesMap[movie.id] = movie;
        } 

        state = { ...state, ...tempMoviesMap };

        return movies;
    }

    Future<void> toogleFavorite( Movie movie ) async {

        await localStorageRepository.toogleFavorite(movie);

        final bool isMovieInFavorites = state[movie.id] != null;

        if( isMovieInFavorites ) {
            state.remove( movie.id );
            state = { ...state, movie.id: movie };
        }

    }

}