import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/presentation/presentation.dart';
import 'package:cinemapedia/domain/domain.dart';
import 'package:go_router/go_router.dart';

class FavoritesView extends ConsumerStatefulWidget {
    const FavoritesView({super.key});
    
    @override
    FavoritesViewState createState() => FavoritesViewState();
}

class FavoritesViewState extends ConsumerState<FavoritesView> {

    bool isLastPage = false;
    bool isLoading = false;

    @override
    void initState() {
        super.initState();
        loadNextPage();
    }

    void loadNextPage() async {
        if( isLoading || isLastPage ) return;

        isLoading = true;

        final movies = await ref.read( favoritesMoviesProvider.notifier ).loadNextPage();

        isLoading = false;

        if( movies.isEmpty ) {
            isLastPage = true;
        }
    }

    @override
    Widget build(BuildContext context) {

        final List<Movie> favoritesMovies = ref.watch( favoritesMoviesProvider ).values.toList();

        if( favoritesMovies.isEmpty ) {

            final colors = Theme.of(context).colorScheme;

            return Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                        Icon( Icons.sentiment_dissatisfied_rounded, size: 60, color: colors.primary ),

                        const Text(
                            'Todavía no has elegido ninguna película favorita', 
                            style: TextStyle( fontSize: 20, color: Colors.white ), 
                            textAlign: TextAlign.center,
                        ),

                        const SizedBox( height: 20 ),
                        
                        FilledButton.tonal(
                            onPressed: () => context.go('/home/0'), 
                            child: const Text('Empieza a buscar')
                        )
                    ],
                ),
            );
        }

        return Scaffold(
            body: MovieMasonry(
                movies: favoritesMovies,
                loadNextPage: loadNextPage,
            )
        );
    }
}