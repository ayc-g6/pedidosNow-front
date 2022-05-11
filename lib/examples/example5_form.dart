/* En este ejemplo describo una página con la siguiente estructura
 * ------------------------
 * 
 *     NumberInputField
 *          Boton
 * 
 * ------------------------
 * 
 * No tiene AppBar ni FloatingActionButton.
 * El botón verifica que el número ingresado esté entre 10 y 18.
 * Si lo es, entonces nos felicita.
 * En caso contrario, nos avisará con un mensajito
 */

import 'package:flutter/material.dart';

class MyNumberFormPage extends StatelessWidget {
  const MyNumberFormPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: MyNumberForm(),
      ),
    );
  }
}

class MyNumberForm extends StatefulWidget {
  const MyNumberForm({Key? key}) : super(key: key);

  @override
  _MyNumberFormState createState() => _MyNumberFormState();
}

class _MyNumberFormState extends State<MyNumberForm> {
  /* Este es un caso raro donde usaremos una key. 
   * Nos servirá para acceder al Form mediante su key o identificador.
   */
  final _formKey = GlobalKey<FormState>();

  String? _input;

  void doTest(context) {
    // Cierro el teclado
    FocusScope.of(context).unfocus();
    /* Al poner '!' aseguramos NOSOTROS que el contenido del atributo
     * currentState NO es null. Podría serlo, pues es de tipo 
     * FormState. Sin embargo, usamos la clave en el Form por lo 
     * que estamos seguros que habrá un estado.
     */

    /* Al llamar a validate(), se ejecuta la función del atributo 'validator',
     * En cada uno de los FormFields que haya con dicho campo, que es opcional.
     * validate() devuelve true si TODOS los validators devolvieron null,
     * false en otro caso.
     */
    if (_formKey.currentState!.validate()) {
      /* Hay muchas formas de obtener el valor en el TextFormField.
       * Mi favorita es llamando a save(), que llama el onSaved()
       * de cada FormField dentro del Form, similar al validator.
       * Otras opciones:
       * - onChanged: onChangedFunction()
       * - controller: myTextEditingController
       */
      _formKey.currentState!.save();

      // El SnackBar es una barra negra que lleva un mensaje.
      final snackBar = SnackBar(
        content: Text('Congratulations! The value is $_input'),
      );
      /* Ojo con usar .of(context), en especial en funciones asincrónicas
       * pues el context se define con el "arbol" de Widgets,
       * y si rajaron este Widget del arbol (ej.: volviendo a la página anterior),
       * entonces su contexto es inválido y rompe la App.
       */
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Tarea para el Lector: Encontrar la documentación oficial de TextFormField
          TextFormField(
            // Personalmente pongo al fondo los atributos con muchas lineas
            onSaved: (String? newValue) => _input = newValue,
            /* decoration: Este atributo permite hints, deshabilitar el campo, cambiar el borde, etc.
             * Seguro lo terminen usando en algún momento.
             */
            validator: (String? value) {
              // En caso de error, se devuelven los mensajes para ser mostrados
              if (value == null || value.isEmpty) {
                return 'El valor no debe ser nulo';
              }
              int convertedValue = int.parse(value);
              if (convertedValue < 10) {
                return 'El valor debe ser mayor a 9';
              }
              if (convertedValue > 18) {
                return 'El valor debe ser menor a 19';
              }
              // En caso de ningún error, devuelvo null.
              return null;
            },
          ),
          TextButton(
            child: const Text('ENTER'),
            /* Pasamos una función anónima, que adentro llama a doTest.
             * No pasamos solo doTest, pues queremos pasarle parámetros,
             * y el atributo onPressed espera una función sin parámetros.
             */
            onPressed: () {
              doTest(context);
            },
          )
        ],
      ),
    );
  }
}
