
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

  final User user;

  /// Ponizej lista stringow do przewijania kategorii
  final itemCounts = [
    'Cały Dom',
    'Salon',
    'Kuchnia',
    'Łazienka',
    'Korytarz',
    'Sypialnia 1',
    'Sypialnia 2',
    'Ogród',
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
                image: AssetImage('white_photo.jpg'),
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
                  margin: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
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
                Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(180, 86, 43, 167),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  padding: const EdgeInsets.all(20.0),
                  margin: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                  child: Column(
                    children: [
                      Text('Jesteś zalogowany jako ${user.email}'),
                      const SizedBox(
                        height: 50,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            FirebaseAuth.instance.signOut();
                          },
                          child: const Text('Wyloguj się'))
                    ],
                  ),
                ),

                ///
                ///
                ///
                Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(0, 86, 43, 167),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  padding: const EdgeInsets.all(5.0),
                  margin: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            children: [
                              FloatingActionButton(
                                  heroTag: "btn5",
                                  onPressed: () {},
                                  child: const Icon(Icons.add)),
                              const SizedBox(
                                height: 4,
                              ),
                              const Text('Dodaj zasady'),
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
                                  heroTag: "btn5",
                                  onPressed: () {},
                                  child: const Icon(Icons.person)),
                              const SizedBox(
                                height: 4,
                              ),
                              const Text('Profil'),
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
                                  heroTag: "btn4",
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (_) => const HeatPage()));
                                  },
                                  child: const Icon(Icons.fireplace_outlined)),
                              const SizedBox(
                                height: 4,
                              ),
                              const Text('Ogrzewanie'),
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
                                  heroTag: "btn3",
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (_) => const LightPage()));
                                  },
                                  child: const Icon(Icons.lightbulb)),
                              const SizedBox(
                                height: 4,
                              ),
                              const Text('Oświetlenie'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                ///
                ///
                ///
                ///
                Container(
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(180, 86, 43, 167),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    height: 200,
                    padding: const EdgeInsets.all(20.0),
                    margin: const EdgeInsets.all(20.0),
                    child: const Center(
                        child: Text(
                            textAlign: TextAlign.center,
                            'Tutaj będą przedstawiane ostatnie działania jakie wydarzyły się w domu od najnowszych do najstarszych z ostatnich 24h'))),
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
            color: Color.fromARGB(180, 86, 43, 167),
          ),
          width: 400,
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
                      color: Color.fromARGB(180, 205, 34, 221),
                    ),
                    margin: const EdgeInsets.all(5.0),
                    padding: const EdgeInsets.all(20.0),
                    height: 60,
                    width: 200,
                    child: Text(itemCount),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Color.fromARGB(180, 221, 34, 34),
                    ),
                    margin: const EdgeInsets.all(5.0),
                    padding: const EdgeInsets.all(20.0),
                    height: 60,
                    width: 175,
                    child: const Text('Temperatura: 15st'),
                  ),
                ],
              ),
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Color.fromARGB(180, 209, 221, 34),
                ),
                margin: const EdgeInsets.all(5.0),
                padding: const EdgeInsets.all(20.0),
                height: 60,
                width: 380,
                child: const Text('container na dane'),
              ),
            ],
          ),
        ),
      ],
    );
