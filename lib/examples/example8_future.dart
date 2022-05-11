/* En este ejemplo cree una página clásica.
 * La estructura de este ejemplo se verá mucho en la App.
 * La idea es:
 * - Tenemos una página que carga datos de una API.
 * - La API no es inmediata, por lo que devuelve un Future que eventualmente se completa.
 * - Mientras el Future no está completado, quiero mostrar un circulito de carga.
 * - Ni bien se haya completado, quiero mostrar la página ya cargada.
 * 
 * Todo esto se puede lograr con un FutureBuilder,
 * que es el Widget protagonista de este ejemplo.
 * El objetivo de esta página es que haya un círculo de carga
 * durante 3 segundos, luego de lo cual aparecerá un 100 en pantalla.
 */

import 'package:flutter/material.dart';

class ExamplePage extends StatelessWidget {
  const ExamplePage({Key? key}) : super(key: key);

  /* Devuelve un Future que luego de 3 segundos toma el valor 100.
   * Esta función típicamente será un API Call.
   */
  Future<int> _getNumber() {
    /* Este es un constructor nombrado de Future para generar
     * delays en la ejecución de código
     */
    return Future.delayed(const Duration(seconds: 3), () => 100);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ejemplo Futures'),
      ),
      /* El FutureBuilder es un Widget que cambia según
       * el estado de un Future.
       * Un Future puede tener 2 estados posibles:
       * - No terminado
       * - Terminado
       */
      body: FutureBuilder(
        // Le indico al FutureBuilder Widget sobre cuál Future trabajar
        future: _getNumber(),
        // El builder es tipo la función build, para hacerle un hijo al FutureBuilder
        /* El AsyncSnapshot es una 'foto' del Future en un momento dado.
         * Por lo tanto, sabe cosas del Future. 
         * El FutureBuilder automáticamente detecta cuando el Future se completó
         */
        builder: (context, AsyncSnapshot<int> snapshot) {
          switch (snapshot.connectionState) {
            // Si el Future no terminó
            case ConnectionState.waiting:
              /* El CircularProgressIndicator es un Widget de Material Design
               * que gira indicando que algo se está cargando.
               */
              return const Center(child: CircularProgressIndicator());
            /* El otro caso es que haya terminado el Future.
             * Utilizamos default y no ConnectionState.done pues hay más
             * estados para ConnectionState, que se utilizan en StreamBuilder.
             * No los necesitamos, pero Flutter lloraría si usamos solo un case para el done,
             * pues no devolvemos nada para los otros valores de ConnectionState. 
             * (Sí, se da cuenta que faltan algunos en el switch)
             */
            default:
              /* Esto nos permite saber mostrar un error en caso de 
               * que el Future haya lanzado una excepción.
               * Muy útil para llamados a API.
               */
              if (snapshot.hasError) {
                // snapshot.error guarda la excepción
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              // En snapshot.data está guardado el valor resultante del Future
              int result = snapshot.data!;
              return Center(child: Text('$result'));
          }
        },
      ),
    );
  }
}
