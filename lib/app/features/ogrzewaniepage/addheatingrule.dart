import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:inteligentny_dom_5/app/features/ogrzewaniepage/getheatingrules.dart';

class AddHeatingRule extends StatefulWidget {
  const AddHeatingRule({
    super.key,
  });

  @override
  State<AddHeatingRule> createState() => _AddHeatingRuleState();
}

class _AddHeatingRuleState extends State<AddHeatingRule> {
  List<GetHeatingRule> myDataList = [];
  final database = FirebaseDatabase.instance.ref();
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  late StreamSubscription _streamSubscription;

  double doubletemperature = 25.00;
  bool rulescolision = false;

  String startTime = '00:00';
  String endTime = '00:00';
  TimeOfDay end = const TimeOfDay(hour: 0, minute: 0);
  TimeOfDay start = const TimeOfDay(hour: 0, minute: 0);
  double starttimedouble = 0.0;
  double endtimedouble = 0.0;
  

  var freeId = 11;
  //var lol = 'domyslny tekst';
  bool? pn = false;
  bool? wt = false;
  bool? sr = false;
  bool? cz = false;
  bool? pt = false;
  bool? so = false;
  bool? nd = false;

  String errorMessage = '';

  List<String> items = <String>[
    'grzejnik - salon',
  ];

  String dropdownValue = 'grzejnik - salon';

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  @override
  void initState() {
    super.initState();
    _activateListeners();
    //_activateListeners2();
  }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ponizej logika sprawdzenia ktore sloty sa wolne tj maja wartosc delete = false
// trzeba ją powtórzyć żeby
//

  // void _activateListeners2() {
  //   _streamSubscription = database.child('/Grzejnik1').onValue.listen((event) {
  //     //final data = event.snapshot.value as Map<String, dynamic>;
  //     //final data = Map<String, dynamic>.from(event.snapshot.value as Map<String, dynamic>);
  //     //final data = Map<Object?, Object?>.from(event.snapshot.value as Map<Object?, Object?>);
  //     //final data = new Map<String, dynamic>.from(event.snapshot.value);
      
      
  //     // powyższe konwersje nie działały, poniżej manualna konwersja

  //     final dynamicValue = event.snapshot.value;
  //     final data = <String, dynamic>{};
  //     if (dynamicValue is Map<dynamic, dynamic>) {
  //       dynamicValue.forEach((key, value) {
  //         if (key is String) {
  //           data[key] = value;
  //         }
  //       });
  //     }

  //     final List<Map<String, dynamic>> mapsList;
  //          mapsList = List<Map<String, dynamic>>.from(data.values);
  //          //mapsList = data.values.toList().cast<Map<String, dynamic>>();

  //     Map<String, dynamic> firstDeletedMap = mapsList.firstWhere(
  //       (map) => map['delete'] == true,
  //       orElse: () => {
  //         'delete': false,
  //         'id': -1
  //       }, // wartość domyślna, gdy nie znajdziemy żadnej mapy z delete=true
  //     );

  //     if (firstDeletedMap['delete'] == true) {
  //       freeId = firstDeletedMap['id'];
  //     } else {
  //       freeId = 11;
  //     }

      
  //   });
  // }

/////////////////////////////////////////////////////////////////////////////////////////////


  void _activateListeners() {
  _streamSubscription = database.child('/Grzejnik1').onValue.listen((event) {
    final dynamicValue = event.snapshot.value;
    final data = <String, dynamic>{};
    

    if (dynamicValue is Map<dynamic, dynamic>) {
      dynamicValue.forEach((key, value) {
        if (key is String) {
          data[key] = value;

          if (data[key]['delete'] == true) { // znalezienie pierwszej zasady która jest usunięta
            freeId = data[key]['id'];
          }



          // znalezienie zasady zawierającej poniedziałek
    //     final mapsList = List<Map<String, dynamic>>.from(data.values);
    //            Map<String, dynamic> poniedzialekMap= mapsList.firstWhere(
    //      (map) => map['delete'] == true,
    //     orElse: () => {
           
    //     }, // wartość domyślna, gdy nie znajdziemy żadnej mapy z delete=true
    //  );

    //  if (poniedzialekMap['delete'] == true) {
    //     rulescolision = true;
    //   } else {
    //     return;
    //    }
       


        }
        




         // pokrywanie się godzin jeśli poniedziałek
            // if (data[key]['pn'] == true) {
            // if ((starttimedouble >= data[key]['start_time_double'] && starttimedouble <= data[key]['end_time_double'])||(endtimedouble >= data[key]['start_time_double'] && endtimedouble <= data[key]['end_time_double']) ){
            //   rulescolision = true;
            // }
            // }else{return;}




      });
    }

    setState(() {
      
    });
  });
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    final grzejnik1 = database.child('/Grzejnik1');

    int temperature = doubletemperature.round();
    double startdouble = start.hour +
        (start.minute /
            60); // format zmiennej jaki będzie można zapisać do bazy danych
    double enddouble = end.hour +
        (end.minute /
            60); // format godziny jaki będzie można zapisać do bazy danych

    starttimedouble = startdouble;
    endtimedouble = enddouble;

    int starttimehour = start.hour;
    int endtimehour = end.hour;
    int starttimeminute = start.minute;
    int endtimeminute = end.minute;

    var map = Map<String, dynamic>.from({
      // to jest mapa która bedzie do wysłania do realtime database po wcisnieciu "dodaj"
      'delete': false,
      'pn': pn,
      'wt': wt,
      'sr': sr,
      'cz': cz,
      'pt': pt,
      'so': so,
      'nd': nd,
      'end_time_hour': endtimehour,
      'end_time_minute': endtimeminute,
      'start_time_hour': starttimehour,
      'start_time_minute': starttimeminute,
      'temperature': temperature,
      'start_time_double': startdouble,
      'end_time_double': enddouble,
    });

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    return AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      surfaceTintColor: const Color.fromARGB(197, 175, 80, 80),
      title: const Center(child: Text('Dodaj zasadę')),
      content: Center(
        child: Column(
          children: [
            const SizedBox(height: 2,),
                  Container(
                      padding: const EdgeInsets.all(5),
                      child: const Text('Wybierz urządzenie')),
                
              
            
            Container(
                padding: const EdgeInsets.all(5),
                child: DropdownButton<String>(
                    value: dropdownValue,
                    items: items.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                          value: value, child: Text(value));
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue ?? '';
                      });
                    })),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    padding: const EdgeInsets.all(5),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Utrzymuj temperaturę: '),
                      ],
                    )),
                Container(
                  padding: const EdgeInsets.all(5),
                  child: Text(temperature.round().toString()),
                ),
                // ok
              ],
            ),
            SizedBox(
              width: 200,
              child: Slider(
                value: doubletemperature,
                onChanged: (value) {
                  setState(() {
                    doubletemperature = value;
                  });
                },
                min: 10.0,
                max: 40.0,
                divisions: 40,
                label: temperature.round().toString(),
              ),
            ),
            Container(
                padding: const EdgeInsets.all(5),
                child: const Text('W godzinach')),
            Container(
              width: 300,
              padding: const EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      padding: const EdgeInsets.all(1), child: const Text('od')),
                  TextButton(
                    onPressed: () async {
                      final selectedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (selectedTime != null) {
                        setState(() {
                          _controller.text = selectedTime.format(context);
                          startTime = selectedTime.format(context);
                          start = selectedTime;
                        });
                      }
                    },
                    child: Text(
                      startTime,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  Container(
                      padding: const EdgeInsets.all(1), child: const Text('do')),
                  TextButton(
                    onPressed: () async {
                      final selectedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (selectedTime != null) {
                        setState(() {
                          _controller2.text = selectedTime.format(context);
                          endTime = selectedTime.format(context);
                          end = selectedTime;
                        });
                      }
                    },
                    child: Text(
                      endTime,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 300,
              padding: const EdgeInsets.all(5),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          padding: const EdgeInsets.all(5),
                          child: const Text('CZAS START')),
                      Container(
                          padding: const EdgeInsets.all(3),
                          child: Text(start.hour.toString())),
                      Container(
                          padding: const EdgeInsets.all(5), child: const Text('h')),
                      Container(
                          padding: const EdgeInsets.all(3),
                          child: Text(start.minute.toString())),
                      Container(
                          padding: const EdgeInsets.all(5), child: const Text('min')),
                    ],
                  ),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    padding: const EdgeInsets.all(5),
                    child: const Text('CZAS STOP')),
                Container(
                    padding: const EdgeInsets.all(5),
                    child: Text(end.hour.toString())),
                Container(
                    padding: const EdgeInsets.all(5), child: const Text('h')),
                Container(
                    padding: const EdgeInsets.all(5),
                    child: Text(end.minute.toString())),
                Container(
                    padding: const EdgeInsets.all(5), child: const Text('min')),
              ],
            ),
                ],
              ),
            ),
           
            Container(
                padding: const EdgeInsets.all(5),
                child: const Text('Dni tygodnia obowiązywania zasady:', textAlign: TextAlign.center,)),
            Container(
              padding: const EdgeInsets.all(0),
              child: Expanded(
                child: Row(
                  
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                              padding: const EdgeInsets.all(0),
                              child: const Text('PN',style: TextStyle(fontSize: 15))),
                          Container(
                            padding: const EdgeInsets.all(0),
                            child: Checkbox(
                              
                              value: pn,
                              activeColor: const Color.fromARGB(255, 85, 202, 7),
                              onChanged: (newBool) {
                                setState(() {
                                  pn = newBool;
                                });
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                              padding: const EdgeInsets.all(0),
                              child: const Text('WT',style: TextStyle(fontSize: 15))),
                          Container(
                            padding: const EdgeInsets.all(0),
                            child: Checkbox(
                              value: wt,
                              activeColor: const Color.fromARGB(255, 85, 202, 7),
                              onChanged: (newBool) {
                                setState(() {
                                  wt = newBool;
                                });
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                              padding: const EdgeInsets.all(0),
                              child: const Text('ŚR',style: TextStyle(fontSize: 15))),
                          Container(
                            padding: const EdgeInsets.all(0),
                            child: Checkbox(
                              value: sr,
                              activeColor: const Color.fromARGB(255, 85, 202, 7),
                              onChanged: (newBool) {
                                setState(() {
                                  sr = newBool;
                                });
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                              padding: const EdgeInsets.all(0),
                              child: const Text('CZ',style: TextStyle(fontSize: 15))),
                          Container(
                            padding: const EdgeInsets.all(0),
                            child: Checkbox(
                              value: cz,
                              activeColor: const Color.fromARGB(255, 85, 202, 7),
                              onChanged: (newBool) {
                                setState(() {
                                  cz = newBool;
                                });
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                              padding: const EdgeInsets.all(0),
                              child: const Text('PT',style: TextStyle(fontSize: 15))),
                          Container(
                            padding: const EdgeInsets.all(0),
                            child: Checkbox(
                              value: pt,
                              activeColor: const Color.fromARGB(255, 85, 202, 7),
                              onChanged: (newBool) {
                                setState(() {
                                  pt = newBool;
                                });
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                              padding: const EdgeInsets.all(0),
                              child: const Text('SO',style: TextStyle(fontSize: 15))),
                          Container(
                            padding: const EdgeInsets.all(0),
                            child: Checkbox(
                              value: so,
                              activeColor: const Color.fromARGB(255, 85, 202, 7),
                              onChanged: (newBool) {
                                setState(() {
                                  so = newBool;
                                });
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                              padding: const EdgeInsets.all(0),
                              child: const Text('ND',style: TextStyle(fontSize: 15))),
                          Container(
                            padding: const EdgeInsets.all(0),
                            child: Checkbox(
                              value: nd,
                              activeColor: const Color.fromARGB(255, 85, 202, 7),
                              onChanged: (newBool) {
                                setState(() {
                                  nd = newBool;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(5),
              child: Text('zasada otrzyma id = $freeId'),
            ),
            Container(
                padding: const EdgeInsets.all(5), child: Text(errorMessage)),

            // Ponizej logika poprawności utworzonej zasady, gdzie teraz umieścić sprawdzenie pokrywania się zasad??

            Builder(builder: (context) {

        
              if (freeId < 11) { //sprawdzenie czy czas zakonczenia zasady jest pozniejszy niz czas rozpoczecia
                if (enddouble > startdouble) { //sprawdzenie czy nie przekroczono maksymalnej ilosci zasad max10
                  if (pn == true || wt == true || sr == true || cz == true || pt == true || so == true || nd == true){

                   return ElevatedButton(
                    onPressed: () async {
                      
                      //rule colision nie działa
                      if(rulescolision == true){
                        const AlertDialog(title: Text('Inna zasada już istnieje!'),content: Text('dla wybranych parametrów czasu określono wartość temperatury'),);
                      }else{
                        setState(() {
                        grzejnik1.child('/Zasada$freeId').update(map);
                        _streamSubscription.cancel();
      
                        
                      });
                      Navigator.of(context).pop();
                      }
                        // w tym miejscu trzeba wstawić mechanizm decydujący do
                        // której zasady dopisać nowe dane
                        // oraz czy nie ma kolizji godzinowej z pozostałymi zasadami



                      
                    },
                    child: const Text('Dodaj Zasadę'),
                  );
                  }else{
                    return const SizedBox(
                      width: 250,
                      child: Text(
                        'Wybierz przynajmniej jeden dzień tygodnia obowiązywania zasady',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Color.fromRGBO(255, 0, 0, 1)),
                      ));
                  }
                 
                } else {
                  return const SizedBox(
                      width: 250,
                      child: Text(
                        'Czas zakończenia musi być późniejszy od czasu rozpoczecia',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Color.fromRGBO(255, 0, 0, 1)),
                      ));
                }
              } else {
                return const SizedBox(
                    width: 250,
                    child: Text(
                      'Osiągnięto maksymalną ilość zasad',
                      
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color.fromRGBO(255, 0, 0, 1)),
                    ));
              }
            }),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Zamknij'),
        ),
      ],
    );
  }

  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  @override
  void deactivate() {
    _streamSubscription.cancel();
    super.deactivate();
  }
}

// dopisac logike pokrywania sie czasowego
