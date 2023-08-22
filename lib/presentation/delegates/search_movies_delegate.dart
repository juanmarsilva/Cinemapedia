import 'dart:async';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/entities/movie.dart';

typedef SearchMoviesCallback = Future<List<Movie>> Function( String query );

class SearchMoviesDelegate extends SearchDelegate<Movie?> {

    final SearchMoviesCallback searchMovies;
    List<Movie> initialMovies;
    StreamController<List<Movie>> debouncedMovies = StreamController.broadcast();
    StreamController<bool> isLoadingStream = StreamController.broadcast();
    Timer? _debounceTimer;


    SearchMoviesDelegate({
        required this.searchMovies,
        required this.initialMovies,
    }):super(
        searchFieldLabel: 'Buscar películas..',
        searchFieldStyle: const TextStyle( fontSize: 18 )
    );

    /*
      ? DEBOUNCE MANUAL
      ? El Timer funciona como un setTimeOut en Js/Ts.
      * Esto nos permite no realizar muchas peticiones en simultaneo mientras el usuario escribe en el buscador. De esta manera una vez que el usuario no escriba por 500 milesimas de segundo ahi recien se va a realizar la peticion para buscar las peliculas.
    */
    void _onQueryChange( String query ) {
        isLoadingStream.add(true);

        if( _debounceTimer?.isActive ?? false ) _debounceTimer!.cancel();

        _debounceTimer = Timer(const Duration( milliseconds: 500 ), () async {
            final movies = await searchMovies(query);
            initialMovies = movies;
            debouncedMovies.add(movies);
            isLoadingStream.add(false);
        });
    }

    void clearStreams() {
        debouncedMovies.close();
    }

    Widget buildResultsAndSuggestions() => StreamBuilder(
        initialData: initialMovies,
        stream: debouncedMovies.stream,
        builder: (context, snapshot) {
    
            final movies = snapshot.data ?? [];
    
            return ListView.builder(
                itemCount: movies.length,
                itemBuilder: (context, index) => _MovieItem(
                    movie: movies[index],
                    onMovieSelected: (context, movie) {
                        clearStreams();
                        close(context, movie);
                    },
                )
            );
        },
    );

    @override
    List<Widget>? buildActions(BuildContext context) {

        return  [

            StreamBuilder(
                initialData: false,
                stream: isLoadingStream.stream, 
                builder: (context, snapshot) {

                    if( snapshot.data ?? false ) {
                        return SpinPerfect(
                            duration: const Duration(seconds: 20),
                            spins: 10,
                            child: IconButton(
                                onPressed: () => query = '', 
                                icon: const Icon( Icons.refresh_rounded )
                            )
                        );
                    }

                    return FadeIn(
                        animate: query.isNotEmpty,
                        child: IconButton(
                            onPressed: () => query = '', 
                            icon: const Icon( Icons.clear_sharp )
                        ),
                    );
                },
            ),

        ];
    }

    @override
    Widget? buildLeading(BuildContext context) {
        return IconButton(
            onPressed: () {
                clearStreams();
                close(context, null);
            }, 
            icon: const Icon(Icons.arrow_back_ios_new_rounded)
        );
    }

    @override
    Widget buildResults(BuildContext context) {
        return buildResultsAndSuggestions();
    }

    @override
    Widget buildSuggestions(BuildContext context) {
        _onQueryChange(query);
        return buildResultsAndSuggestions();
    }
}

class _MovieItem extends StatelessWidget {

    final Movie movie;
    final Function onMovieSelected;

    const _MovieItem({
        required this.movie, 
        required this.onMovieSelected,
    });

    @override
    Widget build(BuildContext context) {

        final textStyles = Theme.of(context).textTheme;
        final size = MediaQuery.of(context).size;

        return FadeIn(
            child: GestureDetector(
                onTap: () {
                    onMovieSelected(context, movie);
                },
                child: Padding(
                    padding: const EdgeInsets.symmetric( horizontal: 10, vertical: 5 ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                
                            //* Image
                            SizedBox(
                                width: size.width *0.2,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.network(
                                        movie.posterPath,
                                        loadingBuilder: (context, child, loadingProgress) => FadeIn(child: child),
                                    ),
                                ),
                            ),
                
                            const SizedBox(
                                width: 10,
                            ),
                
                            //* Description
                            SizedBox(
                                width: size.width * 0.7,
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                
                                        Text(
                                            movie.title,
                                            style: textStyles.titleMedium,    
                                        ),
                
                                        movie.overview.length > 100
                                            ?   Text( '${movie.overview.substring(0, 100)}...' )
                                            :   Text( movie.overview ),
                
                                        Row(
                                            children: [
                                                Icon( Icons.star_half_rounded , color: Colors.yellow.shade900 ),
                                                const SizedBox(width: 5,),
                                                Text( 
                                                    HumanFormarts.number( movie.voteAverage, 1 ),
                                                    style: textStyles.bodyMedium!.copyWith( color: Colors.yellow.shade900 ),
                                                )
                                            ],
                                        )
                                    ],
                                ),
                            )
                
                        ],
                    ),
                ),
            ),
        );
    }
}