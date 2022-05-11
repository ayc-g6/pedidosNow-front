/* Este ejemplo muestra un poco el tema de manejo del estado de un StatefulWidget.
 * El mismo no es ni más ni menos que el que viene con Flutter, con mis comentarios.
 */

import 'package:flutter/material.dart';

class StatefulPage extends StatefulWidget {
  const StatefulPage({Key? key}) : super(key: key);

  @override
  State<StatefulPage> createState() => _StatefulPageState();
}

class _StatefulPageState extends State<StatefulPage> {
  // Nuestro único atributo del estado es un contador
  int _counter = 0;

  void _incrementCounter() {
    /* Al llamar a setState, se actualiza el dato relevante
     * y se vuelve a llamar a build.
     */
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    /* Este método se llama siempre que se dibuja el Widget,
     * osea que al comienzo y una vez por cada llamado a setState()
     */
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              // En textTheme tenemos distintos tamaños y estilos para textos
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      /* El floatingActionButton o FAB es un clásico de Material Design.
       * No es ni más ni menos que un botón flotante.
       */
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        child: const Icon(Icons.add),
      ),
    );
  }
}
