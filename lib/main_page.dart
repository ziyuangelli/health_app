import 'package:flutter/material.dart';
import 'package:health_app/BackendService/SetPreference.dart';
import 'package:health_app/camera.dart';
import 'package:health_app/ingrediant_input_page.dart';
import 'package:health_app/setting_page.dart';
import 'favorite_page.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}
class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;

    final settingButton = IconButton(
        onPressed: () => {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SettingPage()))
        },
        icon: const Icon(Icons.article_outlined),
        iconSize: 40,
    );
    final favButton = IconButton(
        onPressed: () async {
          FavRecipeReceiver.RecipeInfoList = await PreferenceSetter.readStringList("favorite");
          await Future.delayed(const Duration(seconds: 1));
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => FavoritePage()));
        },
        icon: const Icon(Icons.star_outline),
        iconSize: 40,
    );
    final cameraButton = RawMaterialButton(
        onPressed: () => {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage()))
        },
        child: Hero(
            tag: 'camera-icon',
            child: CircleAvatar(
              backgroundColor: Theme.of(context).backgroundColor,
              // backgroundColor: Colors.black,
              radius: 102.5,
              child: CircleAvatar(
                radius: 100,
                backgroundColor: Theme.of(context).canvasColor,
                child: Image.asset('assets/images/camera-icon.png'),
              ),
            )
        ),
    );
    final ingredientInput = Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        onTap: () => {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => IngredientInputPage()))
        },
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.0)
            ),
            prefixIcon: const Align(
                widthFactor: 1.0,
                heightFactor: 1.0,
                child: Icon(
                Icons.search,
            ),
          ),
        ),
      ),
    );

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 10,
            left: 10,
            child: settingButton,
          ),
          Positioned(
              top: 10,
              right: 10,
              child: favButton
          ),
          Positioned.fill(
              child: Align(
                alignment: FractionalOffset(0.5, 0.3),
                child: cameraButton,
              ),
          ),
          Positioned.fill(
            child: Align(
              alignment: FractionalOffset(0.5, 0.7),
              child: Container(
                width: 330,
                child: ingredientInput,
              ),
            ),
          ),
        ],
      ),
    );

  }
}

