import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inteligentny_dom_5/app/features/lightpage/light_page.dart';

import '../ogrzewaniepage/ogrzewaniepage.dart';

class HomePage extends StatelessWidget {
  HomePage({
    required this.user,
    Key? key,
  }) : super(key: key);
  //
//
  final User user;

  /// Ponizej lista stringow do przewijania kategorii
  final itemCounts = [
    'Salon',
    'Kuchnia',
    'Łazienka',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        ///
        ///
        drawer: const Drawer(),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 63, 63, 63),
          centerTitle: true,
          title: const Column(
            children: [
              Text('Smart Home'),
              Text('Just for you'),
            ],
          ),
        ),

        ///
        body:
            // Wszystko owrapowane jest w container ktory dodaje zdjecie jako tło aplikacji
            Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                // AssetImage - jest funkcjonalnością którą jakoś trzeba implementować w Pubspcec.Yaml!!!
                // Fit: BoxFit.Cover umożliwia dociagniecie zdjecia do krawedzi ekranu
                image: AssetImage('assets/photo1.jpg'),
                fit: BoxFit.cover),
          ),
          child: Center(
            child: ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: [
                // w tym miejscu robimu karuzele na containery
                ///
                ///
                ///

                Container(
                  margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  padding: const EdgeInsets.all(0.0),
                  decoration:
                      const BoxDecoration(color: Color.fromARGB(0, 182, 2, 2)),
                  child: CarouselSlider.builder(
                    options: CarouselOptions(
                      viewportFraction: 0.9,
                      height: 200,
                      enableInfiniteScroll: false,
                      initialPage: 0,
                    ),
                    itemCount: itemCounts.length,
                    itemBuilder: (context, index, realIndex) {
                      final itemCount = itemCounts[index];
                      return buildContainer(itemCount, index);
                    },
                  ),
                ),

                ///
                ///
                ///

                ///
                ///
                ///
                ///
                Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(0, 133, 141, 255),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  padding: const EdgeInsets.all(5.0),
                  margin: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Color.fromARGB(186, 76, 83, 180),
                    ),
                    margin: const EdgeInsets.all(5.0),
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Column(
                                    children: [
                                      FloatingActionButton(
                                          backgroundColor: const Color.fromARGB(
                                              255, 117, 194, 93),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                8.0), // Zaokrąglenie krawędzi, 8.0 to przykładowa wartość
                                          ),
                                          heroTag: "btn4",
                                          onPressed: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        const HeatPage()));
                                          },
                                          child: const Icon(
                                              Icons.fireplace_outlined)),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      const Text(
                                        'Ogrzewanie',
                                        style: TextStyle(fontSize: 15.0),
                                        textAlign: TextAlign.center,
                                        softWrap: false,
                                      ),
                                      const Text(
                                        'Automatyczne',
                                        style: TextStyle(fontSize: 15.0),
                                        textAlign: TextAlign.center,
                                        softWrap: false,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Column(
                                    children: [
                                      FloatingActionButton(
                                          backgroundColor: const Color.fromARGB(
                                              255, 117, 194, 93),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                8.0), // Zaokrąglenie krawędzi, 8.0 to przykładowa wartość
                                          ),
                                          heroTag: "btn3",
                                          onPressed: () async {
                                            await Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        const LightPage()));
                                          },
                                          child: const Icon(Icons.front_hand)),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      const Text(
                                        'Sterowanie',
                                        style: TextStyle(fontSize: 15.0),
                                        textAlign: TextAlign.center,
                                        softWrap: false,
                                      ),
                                      const Text(
                                        'Ręczne',
                                        style: TextStyle(fontSize: 15.0),
                                        textAlign: TextAlign.center,
                                        softWrap: false,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Column(
                                    children: [
                                      FloatingActionButton(
                                          backgroundColor: const Color.fromARGB(
                                              255, 117, 194, 93),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                8.0), // Zaokrąglenie krawędzi, 8.0 to przykładowa wartość
                                          ),
                                          heroTag: "btn5",
                                          onPressed: () {},
                                          child: const Icon(Icons.settings)),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      const Text(
                                        'Ustawienia',
                                        style: TextStyle(fontSize: 15.0),
                                        textAlign: TextAlign.center,
                                      ),
                                      const Text(
                                        '',
                                        style: TextStyle(fontSize: 15.0),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Column(
                                    children: [
                                      FloatingActionButton(
                                          backgroundColor: const Color.fromARGB(
                                              255, 117, 194, 93),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                8.0), // Zaokrąglenie krawędzi, 8.0 to przykładowa wartość
                                          ),
                                          heroTag: "btn6",
                                          onPressed: () {},
                                          child: const Icon(Icons.person)),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      const Text(
                                        'Profil',
                                        style: TextStyle(fontSize: 15.0),
                                        textAlign: TextAlign.center,
                                      ),
                                      const Text(
                                        '',
                                        style: TextStyle(fontSize: 15.0),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),

                ///
                ///
                Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(0, 86, 43, 167),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  padding: const EdgeInsets.all(20.0),
                  margin: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                  child: Center(
                    child: Column(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: Color.fromARGB(230, 75, 82, 180),
                          ),
                          margin: const EdgeInsets.all(0.0),
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Text(
                                'Jesteś zalogowany jako: ${user.email}',
                                style: const TextStyle(fontSize: 15.0),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: 1,
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    FirebaseAuth.instance.signOut();
                                  },
                                  child: const Text(
                                    'Wyloguj się',
                                    style: TextStyle(fontSize: 15.0),
                                  ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                ///
                ///
                Container(
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(230, 75, 82, 180),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    height: 200,
                    padding: const EdgeInsets.all(20.0),
                    margin: const EdgeInsets.all(20.0),
                    child: Center(
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Color.fromARGB(0, 102, 41, 216),
                        ),
                        margin: const EdgeInsets.all(5.0),
                        padding: const EdgeInsets.all(20.0),
                        child: const Text(
                          textAlign: TextAlign.center,
                          'Tutaj będą przedstawiane ostatnie działania jakie wydarzyły się w domu od najnowszych do najstarszych z ostatnich 24h',
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ));
  }
}

///
///
///

///
/// Ponizej czesc kodu odpowiedzialna za generowanie kolejnych containerow przewijanej karuzeli
/// Ksztalt containera jest koncepcyjny (trzeba go zrobic jako expandet zeby sie dostosowywyal do szerokosic ekranu)
///

Widget buildContainer(String itemCount, int index) => Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Color.fromARGB(230, 75, 82, 180),
          ),
          width: 300,
          height: 200,
          margin: const EdgeInsets.all(10.0),
          padding: const EdgeInsets.all(0.0),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Color.fromARGB(36, 180, 180, 190),
                    ),
                    margin: const EdgeInsets.all(5.0),
                    padding: const EdgeInsets.all(20.0),
                    height: 60,
                    width: 100,
                    child: Text(
                      itemCount,
                      style: const TextStyle(fontSize: 15.0),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Color.fromARGB(213, 76, 187, 110),
                    ),
                    margin: const EdgeInsets.all(5.0),
                    padding: const EdgeInsets.all(20.0),
                    height: 60,
                    width: 180,
                    child: const Text(
                      'Temperatura: 15st',
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),
                ],
              ),
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Color.fromARGB(158, 75, 81, 117),
                ),
                margin: const EdgeInsets.all(5.0),
                padding: const EdgeInsets.all(20.0),
                height: 80,
                width: 280,
                child: const Center(
                  child: Column(
                    children: [
                      Text(
                        'Stan światła: true',
                        style: TextStyle(fontSize: 15.0),
                      ),
                      Text(
                        'Rolety: 55%',
                        style: TextStyle(fontSize: 15.0),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
