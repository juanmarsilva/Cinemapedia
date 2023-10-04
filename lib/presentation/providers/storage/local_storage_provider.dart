import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/infrastructure/infraestructure.dart';


final localStorageRepositoryProvider = Provider((ref) => LocalStorageRepositoryImpl( IsarDatasource() ));