/* Ejemplo 1
 * En este archivo hago una breve introducción a Dart
 * y las cosas más comunes. No necesita explicación
 */

// Definición de Variables Clásicas
int n = 0;
double f = 3.14;
String palabra = "Facha";
List<int> listaDelSuper = [0, 1, 2, 3];
Map<String, int> diccionario = {'a': 0, 'b': 1};
Set<int> conjunto = {1, 2, 3, 4};

// Variables nulleables.
/* No toda variable puede ser null. 
 * Para serlo, indicar en su tipo que es 'nulleable' con un signo de pregunta.
 * Evitar hacer una variable nulleable a menos que sea absolutamente necesario.
 */
String? nulleable = null;
int? m = null;
/* Los tipos nulleables pueden ser solamente declarados, sin definición.
 * El valor por default es null.
 */
String? oracion;
int? o;

// Clases
class MyClass {
  int x; // Atributo de instancia público
  String? _y; // Atributo de instancia privado
  static int z = 1; // Atributo de clase público
  static double _w = 1.615; // Atributo de clase privado

  // Constructor default, con initializer-list
  MyClass() : x = 0;

  // Constructor con nombre, con initializer list
  MyClass.fromValue(int value) : x = value;

  // Constructor con nombre sin initializer-list
  MyClass.fromIntValue(this.x);

  // Constructor con nombre con diccionario de parámetros
  // Está en todos lados en Flutter
  MyClass.fromDict({required int value}) : x = value;

  // Getter sin lógica en 1 linea con notación flecha
  String? get y => _y;

  // Getter con lógica en varias líneas con notación normal
  double get loco {
    return _w * z;
  }

  // Setter
  set w(double newValue) {
    _w = newValue;
  }

  // Método de Instancia
  String foo() {
    int a = 0;
    a++;
    return 'Quick Maths';
  }

  // Método de Clase
  static void bar() {
    // For
    int counter = 1;
    for (int i = 0; i < 10; i++) {
      counter++;
      // If
      if (counter % 5 == 0) {
        break;
      } else {
        counter += 20;
      }
    }
  }
}

// Funciones Asincrónicas
/* Se ejecutan de forma paralela a nuestro código. 
 * Se indican con el keyword async
 * Su tipo de valor retornado es un Future<T> (o Promesa en otros lenguajes)
 */

Future<int> bar() async {
  int i = 0;
  while (i < 10) {
    // '$variable' pone en el String dicha variable
    // '${expresion}' evalua la expresión (ej: MyClass.y) y pone el resultado en el String
    print('$i');
  }
  return i;
}

void xyz() {
  Future<int> a = bar();
  // No hay garantías de que After Bar se imprima POST los prints de bar(),
  // Pues bar empieza a correrse en paralelo mientras xyz sigue ejecutandose.
  print('After Bar');
}

void uvx() async {
  /* Para esperar que una función asincrónica termine, usamos await.
   * Esto nos permite obtener el valor del Future.
   * Para usar await, nuestra función debe ser async
   */
  int b = await bar();
  // Acá tenemos garantía de que imprimiremos POST bar, pues usamos await
  print('Truly after Bar');
} /* Fin del Ejemplo de Dart Básico */
