// En este ejemplo veremos como hacer que un botón te mande a una nueva página.

import 'package:flutter/material.dart';

class OriginPage extends StatelessWidget {
  const OriginPage({Key? key}) : super(key: key);

  void _goToTargetPage(context) {
    /* El Navigator es quien maneja las páginas.
     * Literalmente es un Stack visualmente y en código. 
     * Si hacen push, ponen algo encima de la vista actual.
     * Si hacen pop, sacan lo último.
     * 
     * En el push pasamos un MaterialPageRoute para que tenga
     * animación de Material Design al ser pusheada.
     * En el pop no necesitamos nada.
     */
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const TargetPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: Text('Go!'),
        onPressed: () => _goToTargetPage(context),
      ),
    );
  }
}

class TargetPage extends StatelessWidget {
  const TargetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Target Page')),
      body: Center(
        child: Column(
          children: [
            const Text('Welcome!'),
            ElevatedButton(
              // Utilizo .pop() para quitar la página
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Return'),
            ),
          ],
        ),
      ),
    );
  }
}
