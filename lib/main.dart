import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // title: 'Dog Show',
      theme: ThemeData(
          primarySwatch: Colors.amber,
          primaryColor: Colors.white,
          textTheme:
              const TextTheme(bodyMedium: TextStyle(color: Colors.white))),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home: const MyHomePage(
        title: 'Dog Show App',
      ),
    );
  }
}

class DogImageWidget extends StatefulWidget {
  const DogImageWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DogImageWidgetState createState() => _DogImageWidgetState();
}

class _DogImageWidgetState extends State<DogImageWidget> {
  String _imageUrl = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDogImage();
  }

  Future<void> _fetchDogImage() async {
    setState(() {
      _isLoading = true;
    });

    final response =
        await http.get(Uri.parse('https://dog.ceo/api/breeds/image/random'));
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final imageUrl = jsonResponse['message'];
      setState(() {
        _imageUrl = imageUrl;
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to fetch dog image');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _isLoading
            ? const SizedBox(
                height: 300,
                width: 300,
                child: CircularProgressIndicator(),
              )
            : Image.network(
                _imageUrl,
                height: 300,
                fit: BoxFit.cover,
              ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _fetchDogImage,
          child: const Text('Another Pup, Please!'),
        ),
      ],
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [Text('Dog Show App')]),
      ),
      body: const Center(
        child: DogImageWidget(),
      ),
    );
  }
}
