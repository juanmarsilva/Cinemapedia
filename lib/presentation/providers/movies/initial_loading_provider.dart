import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';

final initialLoadingProvider = Provider<bool>((ref) {

    final bool hasPopularMovies     = ref.watch( popularMoviesProvider ).isEmpty;
    final bool hasTopRatedMovies    = ref.watch( topRatedMoviesProvider ).isEmpty;
    final bool hasUpcomingMovies    = ref.watch( upcomingMoviesProvider ).isEmpty;
    final bool hasSlidesShowMovies  = ref.watch( moviesSlideshowProvider ).isEmpty;
    final bool hasNowPlayingMovies  = ref.watch( nowPlayingMoviesProvider ).isEmpty;

    if( 
        hasPopularMovies || 
        hasTopRatedMovies || 
        hasUpcomingMovies || 
        hasSlidesShowMovies || 
        hasNowPlayingMovies 
    ) return true;

    return false;
});