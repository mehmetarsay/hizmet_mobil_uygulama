import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hizmet_mobil_uygulama/models/Category.dart';
import 'package:hizmet_mobil_uygulama/models/Hizmet.dart';
import 'package:hizmet_mobil_uygulama/ui/HizmetVerPage.dart';
import 'package:hizmet_mobil_uygulama/viewmodel/hizmet_model.dart';
import 'package:hizmet_mobil_uygulama/viewmodel/user_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'ProfilePage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentNavigationBarIndex;
  Category _category;
  String _profilePhoto;
  PickedFile _profilFoto;
  String _value;
  bool _pressed;
  List<Hizmet> _hizmetler;

  @override
  void initState() {
    super.initState();
    _currentNavigationBarIndex = 0;
    _pressed = false;
    _hizmetler = List<Hizmet>();
    //_hizmetler.add(Hizmet.Info("dsafsadfsafs", "fdsafsdfsa", "_category", "_subCategory", "_publisher", "_detail", "_address", 100.0));
    connectJson();
    readFilterHizmet();
  }

  @override
  Widget build(BuildContext context) {
    UserModel _userModel = Provider.of<UserModel>(context);
    _profilePhoto = _userModel.user.profileURL;
    return WillPopScope(
      onWillPop: () async {
        exit(0);
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.ac_unit_outlined),
          onPressed: () {},
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: (currentIndex) {
            setState(() {
              _currentNavigationBarIndex = currentIndex;
            });
            if (_currentNavigationBarIndex == 1)
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HizmetVerPage(_category)));
          },
          currentIndex: _currentNavigationBarIndex,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined), label: "Anasayfa"),
            BottomNavigationBarItem(
                icon: Icon(Icons.add_box_outlined, size: 40),
                label: "Hizmet Ver"),
            BottomNavigationBarItem(
                icon: Icon(Icons.check_box_outlined, size: 40),
                label: "Hizmetlerim"),
            BottomNavigationBarItem(
                icon: Icon(Icons.chat_outlined), label: "Sohbet")
          ],
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              automaticallyImplyLeading: false,
              actions: [
                Container(
                  width: MediaQuery.of(context).size.width,
                      child:Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: GestureDetector(
                              child: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(_userModel.user.profileURL)),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProfilePage()));
                              },
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 1.2,
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                prefixIcon: IconButton(
                                  icon: Icon(
                                    Icons.search,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _pressed = true;
                                    });
                                  },
                                ),
                                hintText: "Hizmet Ara",
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _value = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                     /* Container(
                        height: 150,
                        child: GridView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 140,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 1),
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                decoration: BoxDecoration(
                                    color: Colors.blue[100 * ((index + 1) % 4)],
                                    gradient: LinearGradient(
                                        colors: [Colors.blue, Colors.green],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomRight)),
                                margin: EdgeInsets.all(18),
                                child: Text("$index. Kutu"),
                              );
                            }),
                      ),*/
                ),
              ],
              floating: true,
            ),
            //BURAYA SLIVER GRID VİEW TARZI BIR SEY GELECEK
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return Card(
                  child: ListTile(
                    title: Text(_hizmetler[index].title),
                    subtitle: Text(_hizmetler[index].detail),
                    leading: Text(_hizmetler[index].hizmetID),
                  ),
                );
                //else return CircularProgressIndicator(backgroundColor: Colors.red,);
              }, childCount: _hizmetler.length),
              /*SliverChildListDelegate(ListView.builder(
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(_hizmetler[index].title),
                      subtitle: Text(_hizmetler[index].detail),
                      leading: Text(_hizmetler[index].hizmetID),
                    ),
                  );
                },
                itemCount: 5,
              ).buildSlivers(context)),*/
            ),
          ],
        ),
      ),
    );
  }

  readFilterHizmet({String category, String subCategory}) async {
    HizmetModel _hizmetModel = Provider.of<HizmetModel>(context, listen: false);
    _hizmetler = await _hizmetModel.readFilterHizmet(
        category: category, subCategory: subCategory);
    debugPrint(_hizmetler.toString());
  }

  void connectJson() {
    DefaultAssetBundle.of(context)
        .loadString("assets/Category.json")
        .then((gelenJson) {
      LinkedHashMap<String, dynamic> map = json.decode(gelenJson.toString());
      _category = Category.fromJson(map);
    }).catchError((onError) => print(onError));
  }

  List<Widget> Search(String value) {
    if (value != null || value != "")
      return List.filled(50, Text(value));
    else
      return Pages();
  }

  List<Widget> Pages() {
    return [
      Text(
        "İlanlar Sayfası",
        style: TextStyle(fontSize: 25, color: Colors.black),
      ),
      Text(
        "İlanlar Sayfası",
        style: TextStyle(fontSize: 25, color: Colors.black),
      ),
      SizedBox(
        height: 300,
      ),
      SizedBox(
        height: 300,
      ),
      Text(
        "İlanlar Sayfası",
        style: TextStyle(fontSize: 25, color: Colors.black),
      ),
      SizedBox(
        height: 300,
      ),
      Text(
        "İlanlar Sayfası",
        style: TextStyle(fontSize: 25, color: Colors.black),
      ),
      SizedBox(
        height: 30,
      ),
      Text(
        "İlanlar Sayfası",
        style: TextStyle(fontSize: 25, color: Colors.black),
      ),
    ];
  }
/*Dialog(child: CarouselSlider(photoPaths:["assets/carouselPhotos/photo1.jpg","assets/carouselPhotos/photo2.jpg","assets/carouselPhotos/photo3.jpg"]),),*/
}
