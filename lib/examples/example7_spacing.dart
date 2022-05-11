/* Este ejemplo busca mostrar las herramientas principales
 * para acomodar y alinear widgets
 * Como tal, pondré cuadrados con colores en una página
 */

import 'package:flutter/material.dart';

class ColorfulPage extends StatelessWidget {
  const ColorfulPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Las columnas acomodan verticalmente sus hijos
    return Column(
      children: [
        // Las filas acomodan horizontalmente sus hijos
        Row(
          // Cuadrados alejados entre ellos
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(height: 80, width: 80, color: Colors.red),
            Container(height: 16, width: 16, color: Colors.blue),
          ],
        ),
        // Una caja de relleno
        const SizedBox(height: 16.0),
        /* El Widget Padding agrega padding a sus hijos. 
         * Si no sabes lo que es Padding, googlealo.
         * No, no es un Margen, pero se parecen.
         * Para definir el padding, usamos el atributo padding, 
         * que recibe un EdgeInsets. Hay 4 constructores nombrados:
         * - all(n): pone n padding de todos lados
         * - fromLTRB(l,t,r,b): abreviación de left, top, right, bottom. Pone dichos paddings
         * - only(left: l, top: t, ...): pone el padding solo en los argumentos usados.
         * - symmetric(horizontal: h, vertical: v): pone paddings simetricos
         * Algunos Widgets traen un atributo padding directamente,
         * para ahorrarnos a nosotros el trabajo de definirlo.
         * Ej: Container(padding: const EdgeInsets.all(8))
         */
        Padding(
          padding: const EdgeInsets.fromLTRB(32.0, 0.0, 16.0, 0),
          child: Row(
            // Alineo verticalmente dentro del row
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(height: 16, width: 16, color: Colors.amber),
              // Toma todo el espacio que sobre
              const Spacer(),
              Container(height: 16, width: 16, color: Colors.green),
              // Otra cajita vacía. En este caso definimos width, pues estamos en un Row
              const SizedBox(width: 8.0),
              Container(height: 32, width: 32, color: Colors.deepPurple[400]),
            ],
          ),
        ),
      ],
    );
  }
}
