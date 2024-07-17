import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Enviar Imagem para API',
      home: UploadImageScreen(),
    );
  }
}

class UploadImageScreen extends StatefulWidget {
  @override
  _UploadImageScreenState createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  File? _image;
  final picker = ImagePicker();
  TextEditingController usuarioController = TextEditingController();
  double latitude = 0.0;
  double longitude = 0.0;

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('Nenhuma imagem selecionada.');
      }
    });
  }

  Future uploadImage() async {
    if (_image == null) {
      return; // Retorna se nenhuma imagem foi selecionada
    }

    String base64Image = base64Encode(_image!.readAsBytesSync());

    // Endpoint e corpo da requisição
    var apiUrl = Uri.parse('http://m2.guilhermesperb.com.br/new');
    var requestBody = jsonEncode({
      "usuario": usuarioController.text,
      "imagem": base64Image,
      "latitude": latitude,
      "longitude": longitude
    });

    try {
      var response = await http.post(
        apiUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: requestBody,
      );

      if (response.statusCode == 200) {
        print('Imagem enviada com sucesso.');
        // Exibir feedback ao usuário se necessário
      } else {
        print('Falha ao enviar imagem. Código de erro: ${response.statusCode}');
        // Exibir feedback ao usuário se necessário
      }
    } catch (e) {
      print('Erro ao enviar imagem: $e');
      // Exibir feedback ao usuário se necessário
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enviar Imagem para API'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: getImage,
              child: Text('Escolher Imagem'),
            ),
            SizedBox(height: 20.0),
            _image == null
                ? Text('Nenhuma imagem selecionada.')
                : Image.file(_image!),
            SizedBox(height: 20.0),
            TextField(
              controller: usuarioController,
              decoration: InputDecoration(
                labelText: 'Usuário',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: uploadImage,
              child: Text('Enviar Imagem'),
            ),
          ],
        ),
      ),
    );
  }
}
