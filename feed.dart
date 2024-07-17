import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Feed de Imagens da API',
      home: FeedScreen(),
    );
  }
}

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  List<Map<String, dynamic>> imagens = [];

  Future fetchFeed() async {
    var apiUrl = Uri.parse('http://m2.guilhermesperb.com.br/feed');

    try {
      var response = await http.get(apiUrl);

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);

        setState(() {
          imagens = jsonData.map((item) => item as Map<String, dynamic>).toList();
        });
      } else {
        print('Falha ao carregar feed. Código de erro: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao carregar feed: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchFeed();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feed de Imagens da API'),
      ),
      body: ListView.builder(
        itemCount: imagens.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(imagens[index]['usuario']),
            subtitle: Image.memory(base64Decode(imagens[index]['imagem'])),
            // Exibir a imagem convertida de Base64
            trailing: Text('${imagens[index]['latitude']}, ${imagens[index]['longitude']}'),
          );
        },
      ),
    );
  }
}
