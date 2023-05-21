
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:inteligentny_dom_5/app/features/ogrzewaniepage/getheatingrules.dart';
import 'package:inteligentny_dom_5/app/features/ogrzewaniepage/hotorcold.dart';


class HeatPage extends StatefulWidget {
  const HeatPage({
    Key? key,
  }) : super(key: key);

  @override
  State<HeatPage> createState() => _HeatPageState();
}

class _HeatPageState extends State<HeatPage> {
  final database = FirebaseDatabase.instance.ref();
 
  var id = 0;
  bool? pn = false;
  bool? wt = false;
  bool? sr = false;
  bool? cz = false;
  bool? pt = false;
  bool? so = false;
  bool? nd = false;
  bool? delete = false;

  // int? start_time_hour = 0;
  // int? endtime_hour = 0;
  // int? start_time_minute = 0;
  // int? end_time_minute = 0;
  // int i = 1;




  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
    
=======
 
>>>>>>> 468fe0f637d3ea53143e9f34f1a864ea5524bb85
  }




  @override
  Widget build(BuildContext context) {
    final grzejnik1 = database.child('/Grzejnik1');

    List<GetHeatingRule> myDataList = [];

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: const Color.fromARGB(255, 178, 187, 243),
                contentPadding: const EdgeInsets.fromLTRB(30, 50, 20, 50),
                title: const Center(child: Text('Wybierz działanie')),
                content: const HotOrCold(),
                actions: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Zamknij'),
                  ),
                ],
              );
            },
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
      drawer: const Drawer(),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 63, 63, 63),
        centerTitle: true,
        title: Center(
            child: Row(children: [
          Container(
              margin: const EdgeInsets.all(20.0),
              padding: const EdgeInsets.all(0.0),
              decoration:
                  const BoxDecoration(color: Color.fromARGB(0, 116, 116, 116)),
              child: const Text('Smarthome')),
          Container(
              margin: const EdgeInsets.all(20.0),
              padding: const EdgeInsets.all(0.0),
              decoration:
                  const BoxDecoration(color: Color.fromRGBO(116, 116, 116, 0)),
              child: const Text('.'))
        ])

            // sprawdzanie statusu online/offline - bedzie odbywać sie na zasadzie wysyłania informacji w jednej zmiennej
            // a odebrania takiej samej w innej w określonym czasie np. 10s

            ),
      ),
      body: StreamBuilder(
        stream: grzejnik1.onValue,
        builder: (context , snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else {
            // Get the data snapshot and convert it to a Map
            if (snapshot.hasData) {
              DataSnapshot dataSnapshot = snapshot.data!.snapshot;
              
<<<<<<< HEAD
              //Map<String, dynamic>? data =
              // dataSnapshot.value as Map<String, dynamic>?;

               final data = Map<String, dynamic>.from(dataSnapshot.value! as Map<Object?, Object?>);
=======
              Map<String, dynamic>? data =
               dataSnapshot.value as Map<String, dynamic>?;

               //final data = Map<String, dynamic>.from(dataSnapshot.value! as Map<Object?, Object?>);
>>>>>>> 468fe0f637d3ea53143e9f34f1a864ea5524bb85

              if (data != null) {
                // process the data
                // Clear the current list of data
                myDataList.clear();

                // Loop through the data and add it to the list
                data.forEach((key, value) {
                  myDataList.add(GetHeatingRule(
                    delete: value['delete'] ?? false,
                    pn: value['pn'] ?? false,
                    wt: value['wt'] ?? false,
                    sr: value['sr'] ?? false,
                    cz: value['cz'] ?? false,
                    pt: value['pt'] ?? false,
                    so: value['so'] ?? false,
                    nd: value['nd'] ?? false,
                    on: value['on'] ?? false,
                    endtimehour: value['end_time_hour'] ?? 0,
                    endtimeminute: value['end_time_minute'] ?? 0,
                    starttimehour: value['start_time_hour'] ?? 0,
                    starttimeminute: value['start_time_minute'] ?? 0,
                    temperature: value['temperature'].toDouble() ?? 0.0,
                    startdouble: value['startdouble'] ?? 0.0,
                    enddouble: value['enddouble'] ?? 0.0,
                    id: value['id'] ?? 0,
                  ));
                });
              } else {
                return const Text('unexpected error');
              }
            }

            // Return a ListView to display the data
            return ListView.builder(
              itemCount: myDataList.length,
              itemBuilder: (BuildContext context, int index) {
                GetHeatingRule data = myDataList[index];

                //poniższy if wybiera tylko te mapy do wyswietlenia ktore nie sa usuniete
                if (!data.delete) {
                  TimeOfDay time1 = TimeOfDay(
                      hour: data.starttimehour, minute: data.starttimeminute);
                  String startTime = time1.format(context);
                  TimeOfDay time2 = TimeOfDay(
                      hour: data.endtimehour, minute: data.endtimeminute);
                  String endTime = time2.format(context);

                  return ListTile(
                    subtitle: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: const Color.fromARGB(255, 133, 141, 255),
                      ),
                      padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                      margin: const EdgeInsets.fromLTRB(5, 5, 40, 5),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            child: const Text('Ikona'),
                          ),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                      padding: const EdgeInsets.all(5),
                                      child:
                                          const Text('Utrzymuj temperaturę: ')),
                                  Text(data.temperature.toString()),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    child: const Text('W godzinach: '),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    child: const Text('od'),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(startTime),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    child: const Text('do'),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(endTime),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    child: const Text('Obowiązuje w: '),
                                  ),
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
                                              value: data.pn,
                                              activeColor: const Color.fromARGB(
                                                  255, 85, 202, 7),
                                              onChanged: null,
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
                                              value: data.wt,
                                              activeColor: const Color.fromARGB(
                                                  255, 85, 202, 7),
                                              onChanged: null,
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
                                              value: data.sr,
                                              activeColor: const Color.fromARGB(
                                                  255, 85, 202, 7),
                                              onChanged: null,
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
                                              value: data.cz,
                                              activeColor: const Color.fromARGB(
                                                  255, 85, 202, 7),
                                              onChanged: null,
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
                                              value: data.pt,
                                              activeColor: const Color.fromARGB(
                                                  255, 85, 202, 7),
                                              onChanged: null,
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
                                              value: data.so,
                                              activeColor: const Color.fromARGB(
                                                  255, 85, 202, 7),
                                              onChanged: null,
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
                                              value: data.nd,
                                              activeColor: const Color.fromARGB(
                                                  255, 85, 202, 7),
                                              onChanged: null,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              ElevatedButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('home page')),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                        255,
                                        243,
                                        33,
                                        33), // set the background color here
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Jesteś pewien?'),
                                          content: const Text(
                                              'Czy napewno chcesz usunąć wybraną zasadę?'),
                                          actions: <Widget>[
                                            TextButton(
                                              child: const Text('Anuluj'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: const Color
                                                        .fromARGB(255, 243, 33,
                                                    33), // set the background color here
                                              ),
                                              child: const Text('Usuń'),
                                              onPressed: () {
                                                // Perform the action here
                                                setState(() {
                                                  int i = data.id;
                                                  grzejnik1
                                                      .child('/Zasada$i')
                                                      .update({'delete': true});
                                                  // w tym miejscu trzeba wstawić mechanizm decydujący do której zasady dopisać nowe dane
                                                  // oraz czy nie ma kolizji godzinowej z pozostałymi zasadami
                                                });
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: const Text('usuń'))
                            ],
                          ),
                        ],
                      ),
                    ),

                    // tutaj odpowiednio rozmieścić dane
                  );
                }if (data.delete == true) {
                  return Container();
                }else{
                  return Container();
                }
              },
            );
          }
        },
      ),
    );
  }

  //poniżej zbieramy dane z zasad aby następnie wyświetlic je w formie listy obowiązujących zasad na
  // podstawie tego czy parametr delete jest true czy false
}

// metoda zawierajaca strukture danych:

