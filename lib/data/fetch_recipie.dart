import 'dart:convert';
import 'package:http/http.dart' as http;
import 'recipie_details.dart';

class SpoonacularRecipes {
  final String apiKey;

  SpoonacularRecipes(this.apiKey);

  Future<List<Future<RecipeWithDetails>>> fetchRecipesByIngredients(String ingredients) async {
    final url = Uri.parse(
        "https://api.spoonacular.com/recipes/search?apiKey=$apiKey&includeIngredients=$ingredients");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final dynamic data = jsonDecode(response.body)["results"];
    if (data != null && data is List) {
      return data.map((recipeJson) => _fetchRecipeDetails(recipeJson)).toList();
    } else {
      throw Exception("Invalid data format");
    }
  }else {
      throw Exception("Failed to fetch recipes");
    }
  }

  Future<RecipeWithDetails?> fetchRecipeByName(String recipeName) async {
    final url = Uri.parse(
        "https://api.spoonacular.com/recipes/search?apiKey=$apiKey&query=$recipeName");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)["results"] as List;
      if (data.isNotEmpty) {
        // Assuming the first recipe is the desired one
        return _fetchRecipeDetails(data[0]);
      } else {
        throw Exception("Invalid data format");// No recipe found
      }
    } else {
      throw Exception("Failed to fetch recipe");
    }
  }

  Future<RecipeWithDetails> _fetchRecipeDetails(Map<String, dynamic> recipeJson) async {
    final recipeId = recipeJson["id"] as int;
    final url = Uri.parse(
        "https://api.spoonacular.com/recipes/$recipeId/information?apiKey=$apiKey&includeInstructions=true");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final details = jsonDecode(response.body);
      return RecipeWithDetails(
        id: recipeJson["id"] as int,
        title: recipeJson["title"] as String,
        image: recipeJson["image"] as String,
        ingredients: (recipeJson["missedIngredients"] as List)
            .map((ingredient) => ingredient["name"] as String)
            .toList(),
        instructions: details["instructions"] as String,
      );
    } else {
      throw Exception("Failed to fetch recipe details");
    }
  }
}
