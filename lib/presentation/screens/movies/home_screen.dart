import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';

import 'package:cinemapedia/presentation/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {

    static const name = 'home-screen';

    const HomeScreen({ super.key });

    @override
    Widget build(BuildContext context) {
        return const Scaffold(
            body: _HomeView(),
            bottomNavigationBar: CustomBottomNavigationBar(),
        );
    }
}

class _HomeView extends ConsumerStatefulWidget {

    const _HomeView();

    @override
    _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<_HomeView> {

    @override
    void initState() {
        super.initState();
        ref.read( nowPlayingMoviesProvider.notifier ).loadNextPage();
    }


    @override
    void dispose() {
        super.dispose();
    }


    @override
    Widget build(BuildContext context) {

        final List<Movie> slidesShowMovies = ref.watch( moviesSlideshowProvider );

        return Column(
          children: [

            const CustomAppBar(),

            MoviesSliceshow(movies: slidesShowMovies )
            
          ],
        );
    }
}