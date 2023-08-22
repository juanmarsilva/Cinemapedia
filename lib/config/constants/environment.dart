

import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {

    static String movieDbKey = dotenv.env['MOVIEDB_KEY'] ?? 'No hay api key';




}