import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/presentation/presentation.dart';
import 'package:cinemapedia/domain/domain.dart';

class FavoritesView extends ConsumerStatefulWidget {
    const FavoritesView({super.key});
    
    @override
    FavoritesViewState createState() => FavoritesViewState();
}

class FavoritesViewState extends ConsumerState<FavoritesView> {

    @override
    void initState() {
        super.initState();
        ref.read( favoritesMoviesProvider.notifier ).loadNextPage();
    }

    @override
    Widget build(BuildContext context) {

        final bool initialLoading = ref.watch( initialLoadingProvider );

        if( initialLoading ) return const FullScreenLoader();

        final List<Movie> favoritesMovies = ref.watch( favoritesMoviesProvider ).values.toList();

        return Scaffold(
            body: ListView.builder(
                itemCount: favoritesMovies.length,
                itemBuilder: (context, index) {

                    final movie = favoritesMovies[index];

                    return ListTile(
                        title: Text( movie.title )
                    );
                }
            ),
        );
    }
}