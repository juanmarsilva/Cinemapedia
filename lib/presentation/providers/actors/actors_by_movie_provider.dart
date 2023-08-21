import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/presentation/providers/actors/actors_repository_provider.dart';


final actorsByMovieProvider = StateNotifierProvider<ActorsByMovieNotifier, Map<String, List<Actor>>>((ref) => 
    ActorsByMovieNotifier(
        getActors: ref.watch( actorRepositoryProvider ).getActorsByMovie
    )
);



/*
    {
        '505642': List<Actor>,
        '505643': List<Actor>,
        '505644': List<Actor>,
        '505645': List<Actor>,
        '505646': List<Actor>,
    }
*/
typedef GetActorsCallback = Future<List<Actor>>Function( String movieId ); 

class ActorsByMovieNotifier extends StateNotifier<Map<String, List<Actor>>> {

    final GetActorsCallback getActors;
    
    ActorsByMovieNotifier({ required this.getActors }): super({});

    Future<void> loadActors( String movieId ) async {
        if( state[movieId] != null ) return;

        final List<Actor> actors = await getActors( movieId );

        state = { ...state, movieId: actors };
    }
}