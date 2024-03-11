import 'package:flutter/material.dart';
import 'data/fetch_recipie.dart';
import 'api/api_test_code.dart';
import 'data/recipie_details.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
  var response1, response2;
  SpoonacularRecipes spoonacularRecipes = SpoonacularRecipes(apiKey);
  @override
  void initState() {
    super.initState();
  }

  fetchData(String searchText) async {
    response1 = await spoonacularRecipes.fetchRecipesByIngredients(searchText);
    print("ran");
    print(await response1.runtimeType);
  }

  TextEditingController _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      floatingActionButton: FloatingActionButton(onPressed: fetchData(_textFieldController.text), child: Icon(Icons.search )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: _textFieldController,
          decoration: InputDecoration(
            hintText: 'Enter some text here',
          ),
        ),
      ),
    );
  }
}
