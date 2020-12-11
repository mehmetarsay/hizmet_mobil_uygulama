import 'dart:collection';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hizmet_mobil_uygulama/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hizmet_mobil_uygulama/models/CarouselSlider.dart';
import 'package:hizmet_mobil_uygulama/models/User.dart';
import 'package:hizmet_mobil_uygulama/utils/DialogMessage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ProfilePage.dart';

/*Tüm firebase verilerini uygulama açılırken almak doğru olmaz */
class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Map<String, Object> currentUser;
  int _currentNavigationBarIndex;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentNavigationBarIndex = 0;
    activeUser();
  }

  activeUser() async {
    SharedPreferences value = await SharedPreferences.getInstance();
    if (firebaseAuth.currentUser.email != null) {
      setState(() {
        value.setInt("login", 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        exit(0);
      },
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: (currentIndex) {
            setState(() {
              _currentNavigationBarIndex = currentIndex;
            });
          },
          currentIndex: _currentNavigationBarIndex,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined), label: "Anasayfa"),
            BottomNavigationBarItem(
                icon: Icon(Icons.add_box_outlined, size: 40), label: "Hizmet Ver"),
            BottomNavigationBarItem(
                icon: Icon(Icons.check_box_outlined, size: 40),
                label: "Hizmetlerim"),
            BottomNavigationBarItem(
                icon: Icon(Icons.chat_outlined), label: "Sohbet")
          ],
        ),

        /*appBar: AppBar(
          actions: [
            Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.account_circle),
                    iconSize: 35,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfilePage()));
                    },
                  ),
                  Text("HİZMET",
                      style: GoogleFonts.hammersmithOne(
                        fontSize: 35,
                        color: Color.fromRGBO(30, 146, 179, 1),
                      )),
                  IconButton(
                    icon: Icon(Icons.search),
                    iconSize: 35,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),*/
        //body: Pages(_currentNavigationBarIndex),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              actions: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.account_circle),
                        iconSize: 35,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfilePage()));
                        },
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 5,horizontal: 60),
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: new BorderRadius.all(
                              new Radius.circular(10.0)), //kenarları yuvarlaklaştırır
                        ),
                        child: Text("Hizmet ara",
                            style: GoogleFonts.roboto(
                              fontSize: 20,
                              color: Color.fromRGBO(30, 146, 179, 0.7),
                            )),
                      ),


                      IconButton(
                        icon: Icon(Icons.search),
                        iconSize: 35,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ],
              floating: true,
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                Pages(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> Pages() {
    return [
      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //crossAxisAlignment: CrossAxisAlignment.end,
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
