import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../fotos_api.dart';

// Slide 8: tira uma foto e envia para o salva.php do meu site,
// junto com a descrição.
class EnviaFoto extends StatefulWidget {
  const EnviaFoto({super.key, required this.url, this.comDescricao = false});

  final String url;
  final bool comDescricao;

  @override
  State<EnviaFoto> createState() => _EnviaFotoState();
}

class _EnviaFotoState extends State<EnviaFoto> {
  final descricao = TextEditingController();
  File? foto;
  String mensagem = '';

  @override
  void dispose() {
    descricao.dispose();
    super.dispose();
  }

  Future<void> tirarFoto() async {
    final arquivo = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 60);
    if (arquivo != null) {
      setState(() => foto = File(arquivo.path));
    }
  }

  Future<void> enviar() async {
    if (foto == null) return;
    setState(() => mensagem = 'Enviando...');
    try {
      final resposta = await FotosApi(widget.url).enviarFoto(
        foto!,
        texto: widget.comDescricao ? descricao.text : null,
      );
      setState(() {
        mensagem = resposta;
        foto = null;
        descricao.clear();
      });
    } catch (e) {
      setState(() => mensagem = 'Erro: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enviar foto')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (widget.comDescricao)
              TextField(
                controller: descricao,
                decoration: const InputDecoration(labelText: 'Descrição'),
              ),
            ElevatedButton(
              onPressed: tirarFoto,
              child: const Text('Tirar foto'),
            ),
            ElevatedButton(
              onPressed: foto == null ? null : enviar,
              child: const Text('Enviar'),
            ),
            Text(mensagem),
            if (foto != null) Expanded(child: Image.file(foto!)),
          ],
        ),
      ),
    );
  }
}
