import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/presentation/providers/movies/movies_providers.dart';


final Provider<List<Movie>> moviesSlideshowProvider = Provider((ref) {

    final nowPlayingMovies = ref.watch( nowPlayingMoviesProvider );

    if( nowPlayingMovies.isEmpty ) return [];

    return nowPlayingMovies.sublist(0, 6);

});