import 'package:flutter/material.dart';

import '../fotos_api.dart';

// Mostra uma foto dado um id, usando o mostra_json.php do meu site.
class MostraFotoId extends StatefulWidget {
  const MostraFotoId({super.key, required this.url});

  final String url;

  @override
  State<MostraFotoId> createState() => _MostraFotoIdState();
}

class _MostraFotoIdState extends State<MostraFotoId> {
  final id = TextEditingController(text: '2');
  Foto? foto;
  String mensagem = '';

  @override
  void dispose() {
    id.dispose();
    super.dispose();
  }

  Future<void> buscar() async {
    setState(() {
      foto = null;
      mensagem = 'Buscando...';
    });
    try {
      final resultado =
          await FotosApi(widget.url).buscarPorId(int.parse(id.text));
      setState(() {
        foto = resultado;
        mensagem = 'ID: ${resultado.id}';
      });
    } catch (e) {
      setState(() => mensagem = 'Erro: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ver foto por id')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: id,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Id'),
            ),
            ElevatedButton(onPressed: buscar, child: const Text('Buscar')),
            Text(mensagem),
            if (foto != null)
              Expanded(child: Image.network(foto!.url(widget.url))),
          ],
        ),
      ),
    );
  }
}
