import 'package:flutter/material.dart';

import 'config.dart';
import 'telas/envia_foto.dart';
import 'telas/galeria.dart';
import 'telas/mostra_foto_id.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Menu(),
    );
  }
}

// Tudo usa o meu site local (XAMPP), endereço em config.dart.
class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    void abrir(Widget tela) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => tela));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Fotos')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ElevatedButton(
            onPressed: () => abrir(
                const EnviaFoto(url: Config.meuSite, comDescricao: true)),
            child: const Text('Enviar foto'),
          ),
          ElevatedButton(
            onPressed: () => abrir(const Galeria(url: Config.meuSite)),
            child: const Text('Ver todas as fotos'),
          ),
          ElevatedButton(
            onPressed: () => abrir(const MostraFotoId(url: Config.meuSite)),
            child: const Text('Ver foto por id'),
          ),
        ],
      ),
    );
  }
}
