
import 'package:cinemapedia/domain/domain.dart';

class ActorRepositoryImpl extends ActorsRepository {

    final ActorsDatasource datasource;

    ActorRepositoryImpl(this.datasource);

    @override
    Future<List<Actor>> getActorsByMovie(String movieId) async {
        return datasource.getActorsByMovie(movieId);
    }

}