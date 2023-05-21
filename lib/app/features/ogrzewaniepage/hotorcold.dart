import 'package:flutter/material.dart';
import 'package:inteligentny_dom_5/app/features/ogrzewaniepage/addheatingrule.dart';


class HotOrCold extends StatelessWidget {
  const HotOrCold({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 100,
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const AddHeatingRule();
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  
                  backgroundColor: const Color.fromARGB(255, 255, 31, 31),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        10), // Ustawienie promienia zaokrąglenia krawędzi
                  ),
                ),
                child: const SizedBox(
                    width: 50,
                    height: 70,
                    child: Icon(
                      Icons.waves,
                      size: 30,
                    ))),
            const Text('Ogrzewanie'),
          ],
        ),
        const SizedBox(
          width: 50,
          height: 1,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        contentPadding: const EdgeInsets.fromLTRB(50, 100, 50, 100),
                        surfaceTintColor: const Color.fromARGB(197, 175, 80, 80),
                        title: const Center(child: Text('Sukces')),
                        content: const Text(
                            'to okno będzie zawierało tworzenie zasad dotyczących chłodzenia'),
                        actions: [
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Zamknij'),
                          ),
                        ],
                      );
                    },
                  );

                  // Akcja wykonywana po kliknięciu przycisku
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 31, 121, 255),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        10), // Ustawienie promienia zaokrąglenia krawędzi
                  ),
                ),
                child: const SizedBox(
                    width: 50,
                    height: 70,
                    child: Icon(
                      Icons.ac_unit,
                      size: 30,
                    ))),
            const Text('Klimatyzacja'),
          ],
        )
      ]),
    );
  }
}