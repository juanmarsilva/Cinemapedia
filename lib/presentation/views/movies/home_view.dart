import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';


class HomeView extends ConsumerStatefulWidget {

    const HomeView({ super.key });

    @override
    HomeViewState createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<HomeView> {

    @override
    void initState() {
        super.initState();
        ref.read( nowPlayingMoviesProvider.notifier ).loadNextPage();
        ref.read( popularMoviesProvider.notifier ).loadNextPage();
        ref.read( topRatedMoviesProvider.notifier ).loadNextPage();
        ref.read( upcomingMoviesProvider.notifier ).loadNextPage();
    }

    @override
    Widget build(BuildContext context) {

        final bool initialLoading = ref.watch( initialLoadingProvider );

        if( initialLoading ) return const FullScreenLoader();

        final List<Movie> popularMovies     = ref.watch( popularMoviesProvider );
        final List<Movie> topRatedMovies    = ref.watch( topRatedMoviesProvider );
        final List<Movie> upcomingMovies    = ref.watch( upcomingMoviesProvider );
        final List<Movie> slidesShowMovies  = ref.watch( moviesSlideshowProvider );
        final List<Movie> nowPlayingMovies  = ref.watch( nowPlayingMoviesProvider );

        return CustomScrollView(
            slivers: [

                const SliverAppBar(
                    floating: true,
                    flexibleSpace: FlexibleSpaceBar(
                        title: CustomAppBar(),
                        centerTitle: true,
                        titlePadding: EdgeInsets.symmetric( horizontal: 8 ),
                    ),
                ),

                SliverList(
                    delegate: SliverChildBuilderDelegate( (context, index) {
                        return Column(
                            children: [
                            
                                MoviesSliceshow(movies: slidesShowMovies ),
                            
                                MovieHorizontalListview(
                                    movies: nowPlayingMovies,
                                    title: 'En cines',
                                    subTitle: 'Lunes 20',
                                    loadNextPage: () => ref.read( nowPlayingMoviesProvider.notifier ).loadNextPage(),
                                ),
                            
                                MovieHorizontalListview(
                                    movies: upcomingMovies,
                                    title: 'Proximamente',
                                    loadNextPage: () => ref.read( upcomingMoviesProvider.notifier ).loadNextPage(),
                                ),
                            
                                MovieHorizontalListview(
                                    movies: popularMovies,
                                    title: 'Populares',
                                    loadNextPage: () => ref.read( popularMoviesProvider.notifier ).loadNextPage(),
                                ),
                            
                                MovieHorizontalListview(
                                    movies: topRatedMovies,
                                    title: 'Mejor calificadas',
                                    loadNextPage: () => ref.read( topRatedMoviesProvider.notifier ).loadNextPage(),
                                ),

                                const SizedBox( height: 50 )
                            
                            ],
                        );
                    }, childCount: 1)
                )
            ]
        );
    }
}