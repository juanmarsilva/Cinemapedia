import 'package:flutter/material.dart';

class FullScreenLoader extends StatelessWidget {

    const FullScreenLoader({
        super.key
    });

    Stream<String> getLoadingMessages() {
        final List<String> messages = [
            'Cargando películas',
            'Comprando palomitas de maíz',
            'Cargando populares',
            'Llamando a mi novia',
            'Zurdos de mierda tiemblen',
            'Aguante Milei'
        ];

        return Stream.periodic( const Duration( milliseconds: 1200 ), (step) {
            return messages[step];
        }).take(messages.length);
    }

    @override
    Widget build(BuildContext context) {
        return Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    const CircularProgressIndicator(
                        strokeWidth: 4,
            
                    ),
                    const SizedBox( height: 10 ),
                    StreamBuilder(
                        stream: getLoadingMessages(),
                        builder: (context, snapshot) {
                            if( !snapshot.hasData ) return const Text('Cargando..');

                            return Text( snapshot.data! );
                        },
                    )
                ],
            ),
        );
    }
}