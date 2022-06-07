import 'package:envios_ya/src/models/auth.dart';
import 'package:envios_ya/src/models/business.dart';
import 'package:envios_ya/src/services/server.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BusinessHome extends StatelessWidget {
  const BusinessHome({Key? key}) : super(key: key);

  /* TODO La idea va a ser poner la info propia del business, tipo perfil.
   * Super básico por ahora. -- Santi
   */
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Server.getMyBusiness(
          Provider.of<Auth>(context, listen: false).accessToken!),
      builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());
          default:
            if (snapshot.hasError || !snapshot.hasData) {
              return const Center(child: Text('Unexpected Error'));
            }
            Business business = Business.fromJson(snapshot.data!);
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Image(image: AssetImage('images/enviosya_logo.png')),
                  const SizedBox(height: 64.0),
                  Text(
                    business.name,
                    style: Theme.of(context).textTheme.displaySmall,
                    maxLines: null,
                  ),
                  const SizedBox(height: 16.0),
                  Text(business.address,
                      style: Theme.of(context).textTheme.subtitle1),
                ],
              ),
            );
        }
      },
    );
  }
}
