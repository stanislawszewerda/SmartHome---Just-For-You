import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class LightPage extends StatefulWidget {
  const LightPage({
    Key? key,
  }) : super(key: key);

  @override
  State<LightPage> createState() => _LightPageState();
}
//
class _LightPageState extends State<LightPage> {
  final database = FirebaseDatabase.instance.ref();
  late StreamSubscription _streamSubscription;
  double? numer;
  bool? zarowka;
  // chyba nie powinno się używać get, sprawdź jak zrobić to inaczej
  var value = false;
  var grzanie = false;
  var swiatlokuchnia = false;
  var swiatlolazienka = false;
  get salon => database.child('/Salon');
  var alarm = false;
  var openlevel = 0;
  var alarmturnedOn = false;

  @override
  void initState() {
    super.initState();
    _activateListeners();
  }

  @override
  Widget build(BuildContext context) {
    //final salon = database.child('/Salon');
    //var on = true;
    //var off = false;

    var percentopenlevel = ((openlevel / 180) * 100).round();
    var doubleopenlevel = openlevel.toDouble();

    return Scaffold(
        //drawer: const Drawer(),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 63, 63, 63),
          centerTitle: true,
          title: Center(
              child: Row(children: [
            Container(
                margin: const EdgeInsets.all(20.0),
                padding: const EdgeInsets.all(0.0),
                decoration: const BoxDecoration(
                    color: Color.fromARGB(0, 116, 116, 116)),
                child: const Text('Smarthome')),
            Container(
                margin: const EdgeInsets.all(20.0),
                padding: const EdgeInsets.all(0.0),
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(116, 116, 116, 0)),
                child: const Text(''))
          ])

              // sprawdzanie statusu online/offline - bedzie odbywać sie na zasadzie wysyłania informacji w jednej zmiennej
              // a odebrania takiej samej w innej w określonym czasie np. 10s

              ),
        ),
        body: Center(
          child: ListView(
            children: [
              Container(
                margin: const EdgeInsets.all(20.0),
                padding: const EdgeInsets.all(0.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: const Color.fromARGB(255, 133, 141, 255)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                          margin: const EdgeInsets.all(20.0),
                          padding: const EdgeInsets.all(0.0),
                          decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 133, 141, 255)),
                          child: const Text(
                            'Światło w salonie',
                            textAlign: TextAlign.center,
                          )),
                    ),

                    Expanded(
                      child: Container(
                        width: 100,
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 133, 141, 255)),
                        child: buildSwitch(),
                      ),
                    ),

                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(20.0),
                        padding: const EdgeInsets.all(0.0),
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 133, 141, 255)),
                        child: const Text(
                          'stan światła: ',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(0.0),
                        padding: const EdgeInsets.all(0.0),
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 133, 141, 255)),
                        child: Text(
                          zarowka.toString(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    //),
                  ],
                ),
                //),
              ),
              Container(
                margin: const EdgeInsets.all(20.0),
                padding: const EdgeInsets.all(0.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: const Color.fromARGB(255, 133, 141, 255)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                          margin: const EdgeInsets.all(10.0),
                          padding: const EdgeInsets.all(0.0),
                          decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 133, 141, 255)),
                          child: const Text(
                            'Światło w kuchni',
                            textAlign: TextAlign.center,
                          )),
                    ),

                    Expanded(
                      child: Container(
                        width: 100,
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 133, 141, 255)),
                        child: buildSwitch2(),
                      ),
                    ),

                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(20.0),
                        padding: const EdgeInsets.all(0.0),
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 133, 141, 255)),
                        child: const Text(
                          'stan światła: ',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(0.0),
                        padding: const EdgeInsets.all(0.0),
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 133, 141, 255)),
                        child: Text(
                          swiatlokuchnia.toString(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    //),
                  ],
                ),
                //),
              ),
              Container(
                margin: const EdgeInsets.all(20.0),
                padding: const EdgeInsets.all(0.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: const Color.fromARGB(255, 133, 141, 255)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                          margin: const EdgeInsets.all(10.0),
                          padding: const EdgeInsets.all(0.0),
                          decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 133, 141, 255)),
                          child: const Text(
                            'Światło w łazience',
                            textAlign: TextAlign.center,
                          )),
                    ),

                    Expanded(
                      child: Container(
                        width: 100,
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 133, 141, 255)),
                        child: buildSwitch3(),
                      ),
                    ),

                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(20.0),
                        padding: const EdgeInsets.all(0.0),
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 133, 141, 255)),
                        child: const Text(
                          'stan światła: ',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(0.0),
                        padding: const EdgeInsets.all(0.0),
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 133, 141, 255)),
                        child: Text(
                          swiatlolazienka.toString(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    //),
                  ],
                ),
                //),
              ),
              Container(
                margin: const EdgeInsets.all(20.0),
                padding: const EdgeInsets.all(0.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: const Color.fromARGB(255, 133, 141, 255)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                          margin: const EdgeInsets.all(20.0),
                          padding: const EdgeInsets.all(0.0),
                          decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 133, 141, 255)),
                          child: const Text(
                            'Włączenie alarmu (czujnik ruchu)',
                            textAlign: TextAlign.center,
                          )),
                    ),

                    Expanded(
                      child: Container(
                        width: 100,
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 133, 141, 255)),
                        child: buildSwitch4(),
                      ),
                    ),

                    //),
                  ],
                ),
                //),
              ),
              Container(
                margin: const EdgeInsets.all(20.0),
                padding: const EdgeInsets.all(0.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: const Color.fromARGB(255, 133, 141, 255)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            padding: const EdgeInsets.all(5),
                            child: const Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Poziom otwarcia rolety - Salon'),
                              ],
                            )),
                        Container(
                          padding: const EdgeInsets.all(5),
                          child: Text('${percentopenlevel.toString()}%'),
                        ),
                        // ok
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            child: const Center(child: Text('zamknięta')),
                          ),
                        ),
                        Expanded(
                          child: SizedBox(
                            width: 300,
                            child: Slider(
                                activeColor:
                                    const Color.fromARGB(255, 136, 240, 105),
                                inactiveColor:
                                    const Color.fromARGB(132, 255, 255, 255),
                                value: doubleopenlevel,
                                onChanged: (openlevel) async {
                                  setState(() {
                                    openlevel = openlevel.roundToDouble();
                                  });
                                  await Future.delayed(
                                      const Duration(milliseconds: 100));
                                  salon.update({"openlevel": openlevel});
                                },
                                min: 0,
                                max: 180,
                                divisions: 40,
                                label: '${percentopenlevel.toString()}%'),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            child: const Center(child: Text('otwarta')),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(20.0),
                padding: const EdgeInsets.all(0.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: const Color.fromARGB(255, 133, 141, 255)),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(20.0),
                        padding: const EdgeInsets.all(0.0),
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 133, 141, 255)),
                        child: const Text('Temperatura z czujnika: '),
                      ),
                    ),
                    Expanded(
                      child: Container(
                          margin: const EdgeInsets.all(20.0),
                          padding: const EdgeInsets.all(0.0),
                          decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 133, 141, 255)),
                          child: Text(numer.toString())),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(20.0),
                padding: const EdgeInsets.all(0.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: const Color.fromARGB(255, 133, 141, 255)),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(20.0),
                        padding: const EdgeInsets.all(0.0),
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 133, 141, 255)),
                        child: const Text('Stan pracy grzejnika w salonie: '),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(20.0),
                        padding: const EdgeInsets.all(0.0),
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 133, 141, 255)),
                        child: Text(grzanie.toString()),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(20.0),
                padding: const EdgeInsets.all(0.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: const Color.fromARGB(255, 133, 141, 255)),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(20.0),
                        padding: const EdgeInsets.all(0.0),
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 133, 141, 255)),
                        child: const Text('Syrena alarmu: '),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(20.0),
                        padding: const EdgeInsets.all(0.0),
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 133, 141, 255)),
                        child: Text(alarm.toString()),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20.0),
                margin: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(const Size(
                          200, 50)), // Zdefiniowanie rozmiaru przycisku
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('powrot do HomePage')),
              )
            ],
          ),
        ));
  }

  void _activateListeners() {
    _streamSubscription = database.child('Salon').onValue.listen(
      (event) {
        final data = event.snapshot.value;
        if (data is Map<dynamic, dynamic>) {
          final temperatura = data['temperatura'] as double?;
          final openlevelget = data['openlevel'] as int?;
          final swiatlo = data['swiatlo'] as bool?;
          final grzalka = data['grzalka'] as bool?;
          final swiatlokuchniaget = data['swiatlo_kuchnia'] as bool?;
          final swiatlolazienkaget = data["swiatlo_lazienka"] as bool?;
          final alarmget = data['alarm'] as bool?;
          final alarmOn = data['alarmOn'] as bool?;
          setState(() {
            numer = temperatura;
            zarowka = swiatlo;
            value = swiatlo!;
            grzanie = grzalka!;
            swiatlokuchnia = swiatlokuchniaget!;
            swiatlolazienka = swiatlolazienkaget!;
            alarm = alarmget!;
            alarmturnedOn = alarmOn!;
            openlevel = openlevelget!;
          });
        }
      },
    );
  }

  Widget buildSwitch() => Switch.adaptive(
        activeColor: const Color.fromARGB(255, 136, 240, 105),
        inactiveThumbColor: const Color.fromARGB(132, 255, 255, 255),
        inactiveTrackColor: const Color.fromARGB(132, 255, 255, 255),
        value: value,
        onChanged: (value) async {
          setState(() {
            this.value = value;
          });
          await Future.delayed(const Duration(milliseconds: 100));
          salon.update({"swiatlo": value});
        },
      );

  Widget buildSwitch2() => Switch.adaptive(
        activeColor: const Color.fromARGB(255, 136, 240, 105),
        inactiveThumbColor: const Color.fromARGB(132, 255, 255, 255),
        inactiveTrackColor: const Color.fromARGB(132, 255, 255, 255),
        value: swiatlokuchnia,
        onChanged: (swiatlokuchnia) async {
          setState(() {
            swiatlokuchnia = swiatlokuchnia;
          });
          await Future.delayed(const Duration(milliseconds: 100));
          salon.update({"swiatlo_kuchnia": swiatlokuchnia});
        },
      );

  Widget buildSwitch3() => Switch.adaptive(
        activeColor: const Color.fromARGB(255, 136, 240, 105),
        inactiveThumbColor: const Color.fromARGB(132, 255, 255, 255),
        inactiveTrackColor: const Color.fromARGB(132, 255, 255, 255),
        value: swiatlolazienka,
        onChanged: (swiatlolazienka) async {
          setState(() {
            swiatlolazienka = swiatlolazienka;
          });
          await Future.delayed(const Duration(milliseconds: 100));
          salon.update({"swiatlo_lazienka": swiatlolazienka});
        },
      );

  Widget buildSwitch4() => Switch.adaptive(
        activeColor: const Color.fromARGB(255, 136, 240, 105),
        inactiveThumbColor: const Color.fromARGB(132, 255, 255, 255),
        inactiveTrackColor: const Color.fromARGB(132, 255, 255, 255),
        value: alarmturnedOn,
        onChanged: (alarmturnedOn) async {
          setState(() {
            alarmturnedOn = alarmturnedOn;
          });

          await Future.delayed(const Duration(milliseconds: 100));
          salon.update({"alarmOn": alarmturnedOn});
        },
      );

  @override
  void deactivate() {
    _streamSubscription.cancel();
    super.deactivate();
  }
}
