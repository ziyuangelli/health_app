import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;

import '../ingrediant_input_page.dart';

class URLGenerator {
  String prefix = "https://www.allrecipes.com/search/results/?search=";

  getRecipePageURL (selectedTags) {
    String fullURL = prefix;

    for (int i = 0; i < selectedTags.length; i++) {
      String addition = "&IngIncl=" + selectedTags[i];
      fullURL = fullURL + addition;
    }
    return fullURL;
  }
}


class SearchResult extends ingredientTags{
  late WebScraper spider;
  late List<String> recipeNames;
  late List<String> imageURLs;
  late List<String> recipePageURLs;
  // List<String> basicInfo = [];

  SearchResult({String recipeURL = "https://www.allrecipes.com/recipe/238581/littlepeeps-truly-baked-potato-salad/#nutrition"}) {
    WebScraper spider = WebScraper();
    spider.extractRecipes(selectedTags);
    spider.extractRecipeInfoURL(recipeURL);
    recipeNames = spider.recipeNames;
    imageURLs = spider.imageURLs;
    recipePageURLs = spider.recipePageURLs;
    // basicInfo = spider.basicInfo;
  }
}

class WebScraper{

  List<String> recipeNames = [];
  List<String> imageURLs = [];
  List<String> recipePageURLs = [];
  List<String> basicInfo = [];

  extractRecipes(selectedTags) async {
    // print("=========== Printing tags ===========");
    // print(SearchResult().tagsForSearch);
    URLGenerator generator = URLGenerator();
    generator.getRecipePageURL(selectedTags);
    String URL = generator.getRecipePageURL(selectedTags);
    // final response = await http.Client().get(Uri.parse("https://www.allrecipes.com/search/results/?search=apple"));
    final response;
    if (URL == "https://www.allrecipes.com/search/results/?search=") {
      response = await http.Client().get(Uri.parse("https://www.allrecipes.com/search/results/?search=apple"));
    } else {
      response = await http.Client().get(Uri.parse(URL));
    }

    if (response.statusCode == 200) {
      var document = parser.parse(response.body);
      try {
        var allNames = document.getElementsByClassName('component card card__recipe card__facetedSearchResult');
        var allImages = document.getElementsByClassName('card__titleLink manual-link-behavior elementFont__title margin-8-bottom');
        var allRecipeURLs = document.getElementsByClassName("card__titleLink manual-link-behavior elementFont__titleLink margin-8-bottom");
        // print("======= length from WebScraper =======");
        // print(allRecipeURLs.length);
        for (int i = 0; i < allNames.length; i++) {
          String recipeName = allNames[i].children[1].children[0].children[0].children[0].text.trim();
          // print("===========================Printing Content===========================");
          // print(recipeName);
          recipeNames.add(recipeName);
        }
        for (int i = 0; i < allImages.length; i++) {
          String? imageURL = allImages[i].children[0].attributes['data-src'];
          // print("===========================Printing Content===========================");
          // print(imageURL);
          imageURLs.add(imageURL as String);
          // imageURLs.add('https://imagesvc.meredithcorp.io/v3/mm/image?url=https%3A%2F%2Fimages.media-allrecipes.com%2Fuserphotos%2F54867.jpg&w=272&h=272&c=sc&poi=face&q=60');
        }
        for (int i = 0; i < allRecipeURLs.length; i++) {
          String? recipePageURL = allRecipeURLs[i].attributes['href'];
          // print("===========================Printing Content===========================");
          // print(recipePageURL);
          recipePageURLs.add(recipePageURL as String);
        }
      } catch (e) {
        return ;
      }
    }
  }

  extractRecipeInfoURL(String RecipeURL) async {
    final response = await http.Client().get(Uri.parse(RecipeURL));

    if (response.statusCode == 200) {
      var document = parser.parse(response.body);
      try {
        var recipeName = document.getElementsByClassName("headline heading-content elementFont__display");
        var imageDiv = document.getElementsByClassName("primary-media-section primary-media-with-filmstrip");
        var basicInfos = document.getElementsByClassName('recipe-meta-container two-subcol-content clearfix recipeMeta');
        // print("======= printing from extractRecipeInfoURL =======");
        // print(RecipeURL);
        // print(imageDiv.length);
        basicInfo.add(recipeName[0].text.trim());
        String? imageURL = imageDiv[0].children[1].children[0].attributes['data-src'];
        print(imageURL);
        basicInfo.add(imageURL!);
        basicInfo.add(basicInfos[0].children[0].children[0].children[1].text.trim());
        basicInfo.add(basicInfos[0].children[0].children[1].children[1].text.trim());
        basicInfo.add(basicInfos[0].children[0].children[2].children[1].text.trim());
        basicInfo.add(basicInfos[0].children[1].children[0].children[1].text.trim());
        basicInfo.add(basicInfos[0].children[1].children[1].children[1].text.trim());
        print(basicInfo[0] + " " + basicInfo[1] + " " + basicInfo[2]);
        return basicInfo;
      } catch (e) {
          print(e);
          return [];
      }
    }
  }



}