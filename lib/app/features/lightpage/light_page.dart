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

class _LightPageState extends State<LightPage> {
  final database = FirebaseDatabase.instance.ref();
  late StreamSubscription _streamSubscription;
  double? numer;
  bool? zarowka;
  // chyba nie powinno się używać get, sprawdź jak zrobić to inaczej
  var value = false;
  var grzanie = false;
  get salon => database.child('/Salon');
  


   @override
  void initState() {
    super.initState();
    _activateListeners();

  }

  @override
  Widget build(BuildContext context) {
    final salon = database.child('/Salon');
    var on = true;
    var off = false;
    

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
          child: Column(
            children: [
              
              Container(
                margin: const EdgeInsets.all(20.0),
                padding: const EdgeInsets.all(0.0),
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 116, 116, 116)),
                child: Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                            margin: const EdgeInsets.all(20.0),
                            padding: const EdgeInsets.all(0.0),
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 116, 116, 116)),
                            child: const Text('Światło w salonie', textAlign: TextAlign.center,)),
                      ),
                      Expanded(
                        child: Container(
                          width: 100,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 116, 116, 116),
                          ),
                          child: buildSwitch(),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.all(20.0),
                          padding: const EdgeInsets.all(0.0),
                          decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 116, 116, 116)),
                          child: const Text('stan światła: ', textAlign: TextAlign.center,),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.all(0.0),
                          padding: const EdgeInsets.all(0.0),
                          decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 116, 116, 116)),
                          child: Text(zarowka.toString(), textAlign: TextAlign.center,),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(20.0),
                padding: const EdgeInsets.all(0.0),
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 116, 116, 116)),
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(20.0),
                      padding: const EdgeInsets.all(0.0),
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 116, 116, 116)),
                      child: const Text('Temperatura z czujnika: '),
                    ),
                    Container(
                        margin: const EdgeInsets.all(20.0),
                        padding: const EdgeInsets.all(0.0),
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 116, 116, 116)),
                        child: Text(numer.toString())),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(20.0),
                padding: const EdgeInsets.all(0.0),
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 116, 116, 116)),
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(20.0),
                      padding: const EdgeInsets.all(0.0),
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 116, 116, 116)),
                      child: const Text('Stan grzałki: '),
                    ),
                   
                  ],
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('powrot do HomePage'))
            ],
          ),
        ));
  }

  void _activateListeners() {  // bardzo prawdopodobne, że należy dodać tutaj async/await i wtedy przestanie zacinać się switch
     _streamSubscription = database.child('Salon').onValue.listen(
      (event) {
        final data = event.snapshot.value;
        if (data is Map<dynamic, dynamic>) {

          
          final temperatura = data['temperatura'] as double?;
          final swiatlo = data['swiatlo'] as bool?;
          final grzalka = data['grzalka'] as bool?;
          setState(() {
            numer = temperatura;
            zarowka = swiatlo;
            value = swiatlo!;
            grzanie = grzalka!;
          });
        }
      },
    );
  }

  Widget buildSwitch() => Switch.adaptive(
        activeColor: const Color.fromARGB(255, 105, 130, 240),
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

       @override
  void deactivate() {
    _streamSubscription.cancel();
    super.deactivate();

  }
}



