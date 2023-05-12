import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:inteligentny_dom_5/app/features/ogrzewaniepage/eksperymet.dart';
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
  
  String startTime = '00:00';
  String endTime = '00:00';
  TimeOfDay end = const TimeOfDay(hour: 0, minute: 0);
  TimeOfDay start = const TimeOfDay(hour: 0, minute: 0);

  var freeId = 11;
  var lol = 'domyslny teskt';
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
  }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  void _activateListeners() {
    _streamSubscription = database.child('/Grzejnik1').onValue.listen((event) {
      final data = event.snapshot.value as Map<String, dynamic>;
      final List<Map<String, dynamic>> mapsList =
          List<Map<String, dynamic>>.from(data.values);

      Map<String, dynamic> firstDeletedMap = mapsList.firstWhere(
        (map) => map['delete'] == true,
        orElse: () => {
          'delete': false,
          'id': -1
        }, // wartość domyślna, gdy nie znajdziemy żadnej mapy z delete=true
        //lol
      );

      if (firstDeletedMap['delete'] == true) {
        freeId = firstDeletedMap['id'];
      } else {
        freeId = 11;

      }

      setState(() {
        final getDeletedId = GetDeletedId.fromRTDB(firstDeletedMap);
        lol = getDeletedId.fancyDiscription();
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
      contentPadding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
      surfaceTintColor: const Color.fromARGB(197, 175, 80, 80),
      title: const Center(child: Text('Dodaj zasadę')),
      content: Column(
        children: [
          Row(
            children: [
              Container(
                  padding: const EdgeInsets.all(5),
                  child: const Text('Wybierz urządzenie')),
             
            ],
          ),
           Container(
                  padding: const EdgeInsets.all(5),
                  child: DropdownButton<String>(
                      value: dropdownValue,
                      items:
                          items.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                            value: value, child: Text(value));
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue ?? '';
                        });
                      })),
          Row(
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
          Slider(
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
          Container(
              padding: const EdgeInsets.all(5),
              child: const Text('W godzinach')),
          Row(
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
          Row(
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
          Container(
              padding: const EdgeInsets.all(5),
              child: const Text('Dni tygodnia obowiązywania zasady:')),
          Row(
            children: [
              Column(
                children: [
                  Container(
                      padding: const EdgeInsets.all(0),
                      child: const Text('PN')),
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
              Column(
                children: [
                  Container(
                      padding: const EdgeInsets.all(0),
                      child: const Text('WT')),
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
              Column(
                children: [
                  Container(
                      padding: const EdgeInsets.all(0),
                      child: const Text('ŚR')),
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
              Column(
                children: [
                  Container(
                      padding: const EdgeInsets.all(0),
                      child: const Text('CZ')),
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
              Column(
                children: [
                  Container(
                      padding: const EdgeInsets.all(0),
                      child: const Text('PT')),
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
              Column(
                children: [
                  Container(
                      padding: const EdgeInsets.all(0),
                      child: const Text('SO')),
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
              Column(
                children: [
                  Container(
                      padding: const EdgeInsets.all(0),
                      child: const Text('ND')),
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
            ],
          ),
          Container(
            padding: const EdgeInsets.all(5),
            child: Text('zasada otrzyma id = $freeId'),
          ),
          Container(
              padding: const EdgeInsets.all(5), child: Text(errorMessage)),
          Builder(
            builder: (context) {
              if(enddouble>startdouble){
               if(freeId<11){return ElevatedButton(
                onPressed: () async {
                  setState(() {
                    
                    grzejnik1.child('/Zasada$freeId').update(map);

                    // w tym miejscu trzeba wstawić mechanizm decydujący do
                    // której zasady dopisać nowe dane
                    // oraz czy nie ma kolizji godzinowej z pozostałymi zasadami
                  });
                  Navigator.of(context).pop();
                  
                },
                child: const Text('Dodaj Zasadę'),
              );}else{
                return const SizedBox(width: 250, child: Text('Osiągnięto maksymalną ilość zasad', textAlign: TextAlign.center, style: TextStyle(color: Color.fromRGBO(255, 0, 0, 1)),));
              }
              }else{
                return const SizedBox(width: 250, child: Text('Czas zakończenia musi być późniejszy od czasu rozpoczecia', textAlign: TextAlign.center, style: TextStyle(color: Color.fromRGBO(255, 0, 0, 1)),));
              }
              
             
              
            }
          ),
        ],
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
