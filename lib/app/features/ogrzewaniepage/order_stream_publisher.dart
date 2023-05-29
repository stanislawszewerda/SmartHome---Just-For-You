// import 'package:firebase_database/firebase_database.dart';
// import 'package:inteligentny_dom_5/app/features/ogrzewaniepage/getheatingrules.dart';

// class GetHeatingRuleStreamPublisher {
//   final _database = FirebaseDatabase.instance.ref();

// Stream<List<GetHeatingRule>> getHeatingRuleStream() {
// final getHeatingRuleStream = _database.child('/Grzejnik1').onValue;
// final streamToPublish = getHeatingRuleStream.map((event) {
// final getheatingruleMap = Map<String, dynamic>.from(event.snapshot.value as Map<String, dynamic>);
// final getheatingruleList = getheatingruleMap.entries.map((element)
// {
// return GetHeatingRule.fromRTDB(Map<String, dynamic>.from(element.value));
// }).toList();


// return getheatingruleList;
// });
// return streamToPublish;
// }
// }

