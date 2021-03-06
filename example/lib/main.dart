import 'package:dynamic_url_image_cache/dynamic_url_image_cache.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dynamic Url Image Cache',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _resetButtonHandler() {
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => MyHomePage()), (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dynamic Url Image Cache"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              image: DynamicUrlImageCache(
                imageId: 'testIdImage129',
                imageUrl: 'https://picsum.photos/200/200',
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _resetButtonHandler,
        tooltip: 'Reset',
        child: Icon(Icons.refresh),
      ),
    );
  }
}
