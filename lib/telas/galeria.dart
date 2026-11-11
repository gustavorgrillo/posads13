import 'package:flutter/material.dart';

import '../fotos_api.dart';

// Slide 8: mostra todas as fotos do meu site, uma por vez.
class Galeria extends StatefulWidget {
  const Galeria({super.key, required this.url});

  final String url;

  @override
  State<Galeria> createState() => _GaleriaState();
}

class _GaleriaState extends State<Galeria> {
  List<Foto> fotos = [];
  int atual = 0;
  String mensagem = 'Carregando...';

  @override
  void initState() {
    super.initState();
    carregar();
  }

  Future<void> carregar() async {
    try {
      final lista = await FotosApi(widget.url).listar();
      setState(() {
        fotos = lista;
        mensagem = lista.isEmpty ? 'Nenhuma foto' : '';
      });
    } catch (e) {
      setState(() => mensagem = 'Erro: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todas as fotos')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: fotos.isEmpty
            ? Text(mensagem)
            : Column(
                children: [
                  Text('Foto ${atual + 1} de ${fotos.length}'),
                  Expanded(
                      child: Image.network(fotos[atual].url(widget.url))),
                  Text(fotos[atual].texto),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed:
                            atual > 0 ? () => setState(() => atual--) : null,
                        child: const Text('Anterior'),
                      ),
                      ElevatedButton(
                        onPressed: atual < fotos.length - 1
                            ? () => setState(() => atual++)
                            : null,
                        child: const Text('Próxima'),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
