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

  bool rulescolisionPN = false;
  bool rulescolisionWT = false;
  bool rulescolisionSR = false;
  bool rulescolisionCZ = false;
  bool rulescolisionPT = false;
  bool rulescolisionSO = false;
  bool rulescolisionND = false;

  double starttimePN = 0.0;
  double starttimeWT = 0.0;
  double starttimeSR = 0.0;
  double starttimeCZ = 0.0;
  double starttimePT = 0.0;
  double starttimeSO = 0.0;
  double starttimeND = 0.0;

  double endtimePN = 0.0;
  double endtimeWT = 0.0;
  double endtimeSR = 0.0;
  double endtimeCZ = 0.0;
  double endtimePT = 0.0;
  double endtimeSO = 0.0;
  double endtimeND = 0.0;

  String startTime = '00:00';
  String endTime = '00:00';
  TimeOfDay end = const TimeOfDay(hour: 0, minute: 0);
  TimeOfDay start = const TimeOfDay(hour: 0, minute: 0);
  double starttimedouble = 0.0;
  double endtimedouble = 0.0;

  var freeId = 11;
  //var lol = 'domyslny tekst';
  bool poniedzialek = true;
  bool pn = false;
  bool wt = false;
  bool sr = false;
  bool cz = false;
  bool pt = false;
  bool so = false;
  bool nd = false;
  String test = 'lol';

  var pn1 = true;

  String errorMessage = '';

  List<String> items = <String>[
    'grzejnik - salon',
  ];

  String dropdownValue = 'grzejnik - salon';

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  @override
  void initState() {
    super.initState();
    _activateListeners(
      pn,
      wt,
      sr,
      cz,
      pt,
      so,
      nd

    );
    //_activateListeners2();
  }

  void _activateListeners(bool pn, bool wt, bool sr, bool cz, bool pt, bool so, bool nd) {

    
    

    _streamSubscription =
        database.child('/Grzejnik1').onValue.listen((event) {
      final dynamicValue = event.snapshot.value;
      final data = <String, dynamic>{};

      if (dynamicValue is Map<dynamic, dynamic>) {
        dynamicValue.forEach((key, value) {
          if (key is String) {
            data[key] = value;


            final List<Map<dynamic, dynamic>> mapsList;
            mapsList = List<Map<dynamic, dynamic>>.from(dynamicValue.values);

            //// wyszukiwanie dowolnego ID usuniętej mapy (znajdowanie miejsca na wartości nowej zasady)

            Map<dynamic, dynamic> firstDeletedMap = mapsList.firstWhere(
              (map) => map['delete'] == true,
              orElse: () => {
                'delete': false,
                'id': -1
              }, // wartość domyślna, gdy nie znajdziemy żadnej mapy z delete=true
            );

            if (firstDeletedMap['delete'] == true) {
              freeId = firstDeletedMap['id'];
            } else {
              freeId = 11;
            }

            //// koniec wyszukiwania dowolnego ID usuniętej zasady
            ///
            ///TERAZ: wyszukaj wszystkie obowiązujące już zasady (pokaż ich id)
            ///Sprawdz czy jakakolwiek zasada pokrywa się w czasie z tą którą chce dodać użytkownik

            List<Map<dynamic, dynamic>> activeMaps =
                mapsList.where((map) => map['delete'] == false).toList();

            for (var activeMap in activeMaps) {
              var usedId = activeMap['id'];
              for (int id = 1; id <= 10; id++){
              if (usedId == id) {
                if (activeMap['pn'] == true && pn == true) {
                  // tutaj logika dotyczaca godziny
                  if((starttimedouble > activeMap['start_time_double'] && starttimedouble < activeMap['end_time_double'])||
                  (endtimedouble > activeMap['start_time_double'] && endtimedouble < activeMap['end_time_double'])||
                  (endtimedouble > activeMap['end_time_double'] && starttimedouble < activeMap['start_time_double'])||
                  (endtimedouble == activeMap['end_time_double'])||(starttimedouble == activeMap['start_time_double'])

                  ){ if(mounted){  //mounted jest potrzebne bo jak zamyka sie widget alert dialog to nie mozna wiecej ustawiac setstate
                    setState(() {
                    test = 'zdeklarowane ramy czasowe występują już w zasadzie id$usedId';
                    return;
                  });
                  
                  
                }}

                 
              }else if (activeMap['wt'] == true && wt == true) {
                 // tutaj logika dotyczaca godziny
                  if((starttimedouble > activeMap['start_time_double'] && starttimedouble < activeMap['end_time_double'])||
                  (endtimedouble > activeMap['start_time_double'] && endtimedouble < activeMap['end_time_double'])||
                  (endtimedouble > activeMap['end_time_double'] && starttimedouble < activeMap['start_time_double'])||
                  (endtimedouble == activeMap['end_time_double'])||(starttimedouble == activeMap['start_time_double'])

                  ){ if(mounted){  //mounted jest potrzebne bo jak zamyka sie widget alert dialog to nie mozna wiecej ustawiac setstate
                    setState(() {
                    test = 'zdeklarowane ramy czasowe występują już w zasadzie id$usedId';
                    
                  }
                  );
                  return;
                  
                }
                return;
                }
                
              }else
               if (activeMap['sr'] == true && sr == true) {
                   // tutaj logika dotyczaca godziny
                  if((starttimedouble > activeMap['start_time_double'] && starttimedouble < activeMap['end_time_double'])||
                  (endtimedouble > activeMap['start_time_double'] && endtimedouble < activeMap['end_time_double'])||
                  (endtimedouble > activeMap['end_time_double'] && starttimedouble < activeMap['start_time_double'])||
                  (endtimedouble == activeMap['end_time_double'])||(starttimedouble == activeMap['start_time_double'])

                  ){ if(mounted){  //mounted jest potrzebne bo jak zamyka sie widget alert dialog to nie mozna wiecej ustawiac setstate
                    setState(() {
                    test = 'zdeklarowane ramy czasowe występują już w zasadzie id$usedId';
                    
                  });
                  return;
                  
                }
                return;
                }
              }else
               if (activeMap['cz'] == true && cz == true) {
                  // tutaj logika dotyczaca godziny
                  if((starttimedouble > activeMap['start_time_double'] && starttimedouble < activeMap['end_time_double'])||
                  (endtimedouble > activeMap['start_time_double'] && endtimedouble < activeMap['end_time_double'])||
                  (endtimedouble > activeMap['end_time_double'] && starttimedouble < activeMap['start_time_double'])||
                  (endtimedouble == activeMap['end_time_double'])||(starttimedouble == activeMap['start_time_double'])

                  ){ if(mounted){  //mounted jest potrzebne bo jak zamyka sie widget alert dialog to nie mozna wiecej ustawiac setstate
                    setState(() {
                    test = 'zdeklarowane ramy czasowe występują już w zasadzie id$usedId';
                    
                  });
                  return;
                  
                }
                return;
                }
              }else
               if (activeMap['pt'] == true && pt == true) {
                // tutaj logika dotyczaca godziny
                  if((starttimedouble > activeMap['start_time_double'] && starttimedouble < activeMap['end_time_double'])||
                  (endtimedouble > activeMap['start_time_double'] && endtimedouble < activeMap['end_time_double'])||
                  (endtimedouble > activeMap['end_time_double'] && starttimedouble < activeMap['start_time_double'])||
                  (endtimedouble == activeMap['end_time_double'])||(starttimedouble == activeMap['start_time_double'])

                  ){ if(mounted){  //mounted jest potrzebne bo jak zamyka sie widget alert dialog to nie mozna wiecej ustawiac setstate
                    setState(() {
                    test = 'zdeklarowane ramy czasowe występują już w zasadzie id$usedId';
                    
                  });
                  return;
                  
                  
                }
                return;
                }
              }else
               if (activeMap['so'] == true && so == true) {
                  // tutaj logika dotyczaca godziny
                  if((starttimedouble > activeMap['start_time_double'] && starttimedouble < activeMap['end_time_double'])||
                  (endtimedouble > activeMap['start_time_double'] && endtimedouble < activeMap['end_time_double'])||
                  (endtimedouble > activeMap['end_time_double'] && starttimedouble < activeMap['start_time_double'])||
                  (endtimedouble == activeMap['end_time_double'])||(starttimedouble == activeMap['start_time_double'])

                  ){ if(mounted){  //mounted jest potrzebne bo jak zamyka sie widget alert dialog to nie mozna wiecej ustawiac setstate
                    setState(() {
                    test = 'zdeklarowane ramy czasowe występują już w zasadzie id$usedId';
                    
                  });
                  return;
                  
                }
                return;
                }
              }else
               if (activeMap['nd'] == true && nd == true) {
                // tutaj logika dotyczaca godziny
                  if((starttimedouble > activeMap['start_time_double'] && starttimedouble < activeMap['end_time_double'])||
                  (endtimedouble > activeMap['start_time_double'] && endtimedouble < activeMap['end_time_double'])||
                  (endtimedouble > activeMap['end_time_double'] && starttimedouble < activeMap['start_time_double'])||
                  (endtimedouble == activeMap['end_time_double'])||(starttimedouble == activeMap['start_time_double'])

                  ){ if(mounted){  //mounted jest potrzebne bo jak zamyka sie widget alert dialog to nie mozna wiecej ustawiac setstate
                    setState(() {
                    test = 'zdeklarowane ramy czasowe występują już w zasadzie id$usedId';
                    
                  });
                  return;
                  
                }
                return;
                }
              }
              
              else{if(mounted){  //mounted jest potrzebne bo jak zamyka sie widget alert dialog to nie mozna wiecej ustawiac setstate
                    setState(() {
                    test = 'mozna dodac taka zasade';
                  });}
              
              }
      
              }
          
              }
            }
          }
        });
      }
    });
  }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {

    
    _activateListeners( pn,
      wt,
      sr,
      cz,
      pt,
      so,
      nd);
   
    
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

    var tosend = Map<String, dynamic>.from({
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
            const SizedBox(
              height: 2,
            ),
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
                      padding: const EdgeInsets.all(1),
                      child: const Text('od')),
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
                      padding: const EdgeInsets.all(1),
                      child: const Text('do')),
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
                          padding: const EdgeInsets.all(5),
                          child: const Text('h')),
                      Container(
                          padding: const EdgeInsets.all(3),
                          child: Text(start.minute.toString())),
                      Container(
                          padding: const EdgeInsets.all(5),
                          child: const Text('min')),
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
                          padding: const EdgeInsets.all(5),
                          child: const Text('h')),
                      Container(
                          padding: const EdgeInsets.all(5),
                          child: Text(end.minute.toString())),
                      Container(
                          padding: const EdgeInsets.all(5),
                          child: const Text('min')),
                    ],
                  ),
                ],
              ),
            ),

            Container(
                padding: const EdgeInsets.all(5),
                child: const Text(
                  'Dni tygodnia obowiązywania zasady:',
                  textAlign: TextAlign.center,
                )),
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
                              child: const Text('PN',
                                  style: TextStyle(fontSize: 15))),
                          Container(
                            padding: const EdgeInsets.all(0),
                            child: Checkbox(
                              value: pn,
                              activeColor:
                                  const Color.fromARGB(255, 85, 202, 7),
                              onChanged: (newBool) {
                                setState(() {
                                  if (newBool != null) {
                                    pn = newBool;
                                  }
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
                              child: const Text('WT',
                                  style: TextStyle(fontSize: 15))),
                          Container(
                            padding: const EdgeInsets.all(0),
                            child: Checkbox(
                              value: wt,
                              activeColor:
                                  const Color.fromARGB(255, 85, 202, 7),
                              onChanged: (newBool) {
                                setState(() {
                                  if (newBool != null) {
                                    wt = newBool;
                                  }
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
                              child: const Text('ŚR',
                                  style: TextStyle(fontSize: 15))),
                          Container(
                            padding: const EdgeInsets.all(0),
                            child: Checkbox(
                              value: sr,
                              activeColor:
                                  const Color.fromARGB(255, 85, 202, 7),
                              onChanged: (newBool) {
                                setState(() {
                                  if (newBool != null) {
                                    sr = newBool;
                                  }
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
                              child: const Text('CZ',
                                  style: TextStyle(fontSize: 15))),
                          Container(
                            padding: const EdgeInsets.all(0),
                            child: Checkbox(
                              value: cz,
                              activeColor:
                                  const Color.fromARGB(255, 85, 202, 7),
                              onChanged: (newBool) {
                                setState(() {
                                  if (newBool != null) {
                                    cz = newBool;
                                  }
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
                              child: const Text('PT',
                                  style: TextStyle(fontSize: 15))),
                          Container(
                            padding: const EdgeInsets.all(0),
                            child: Checkbox(
                              value: pt,
                              activeColor:
                                  const Color.fromARGB(255, 85, 202, 7),
                              onChanged: (newBool) {
                                setState(() {
                                  if (newBool != null) {
                                    pt = newBool;
                                  }
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
                              child: const Text('SO',
                                  style: TextStyle(fontSize: 15))),
                          Container(
                            padding: const EdgeInsets.all(0),
                            child: Checkbox(
                              value: so,
                              activeColor:
                                  const Color.fromARGB(255, 85, 202, 7),
                              onChanged: (newBool) {
                                setState(() {
                                  if (newBool != null) {
                                    so = newBool;
                                  }
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
                              child: const Text('ND',
                                  style: TextStyle(fontSize: 15))),
                          Container(
                            padding: const EdgeInsets.all(0),
                            child: Checkbox(
                              value: nd,
                              activeColor:
                                  const Color.fromARGB(255, 85, 202, 7),
                              onChanged: (newBool) {
                                setState(() {
                                  if (newBool != null) {
                                    nd = newBool;
                                  }
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
              if (freeId < 11) {
                //sprawdzenie czy czas zakonczenia zasady jest pozniejszy niz czas rozpoczecia
                if (enddouble > startdouble) {
                  //sprawdzenie czy nie przekroczono maksymalnej ilosci zasad max10
                  if (pn == true ||
                      wt == true ||
                      sr == true ||
                      cz == true ||
                      pt == true ||
                      so == true ||
                      nd == true) {
                    return ElevatedButton(
                      onPressed: () {
                        //rule colision nie działa
                        _streamSubscription.cancel();
                        setState(() {
                          grzejnik1.child('/Zasada$freeId').update(tosend);
                        });
                        Navigator.of(context).pop();

                        // w tym miejscu trzeba wstawić mechanizm decydujący do
                        // której zasady dopisać nowe dane
                        // oraz czy nie ma kolizji godzinowej z pozostałymi zasadami
                      },
                      child: const Text('Dodaj Zasadę'),
                    );
                  } else {
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
            Builder(builder: (context) {
              
                return Text(test);
              
            })
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

  //////////////////////

  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  @override
  void deactivate() {
    //_streamSubscription.cancel();
    super.deactivate();
  }
  
 
}

// dopisac logike pokrywania sie czasowego
