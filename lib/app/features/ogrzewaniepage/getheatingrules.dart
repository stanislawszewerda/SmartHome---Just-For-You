// klasa wykorzystywana do pobierania informacji o grzejnik1 przez ogrzewaniepage.dart
// oraz addheatingrule.dart

class GetHeatingRule {
  final bool delete;
  final bool pn;
  final bool wt;
  final bool sr;
  final bool cz;
  final bool pt;
  final bool so;
  final bool nd;
  final bool on;
  final int endtimehour;
  final int endtimeminute;
  final int starttimehour;
  final int starttimeminute;
  final int temperature;
  final double startdouble;
  final double enddouble;
  final int id;

  GetHeatingRule({
    required this.delete,
    required this.pn,
    required this.wt,
    required this.sr,
    required this.cz,
    required this.pt,
    required this.so,
    required this.nd,
    required this.on,
    required this.endtimehour,
    required this.endtimeminute,
    required this.starttimehour,
    required this.starttimeminute,
    required this.temperature,
    required this.startdouble,
    required this.enddouble,
    required this.id,
  });


factory GetHeatingRule.fromRTDB(Map<String, dynamic> data){
  return GetHeatingRule(
    delete: data['delete'] ?? false,
                    pn: data['pn'] ?? false,
                    wt: data['wt'] ?? false,
                    sr: data['sr'] ?? false,
                    cz: data['cz'] ?? false,
                    pt: data['pt'] ?? false,
                    so: data['so'] ?? false,
                    nd: data['nd'] ?? false,
                    on: data['on'] ?? false,
                    endtimehour: data['end_time_hour'] ?? 0,
                    endtimeminute: data['end_time_minute'] ?? 0,
                    starttimehour: data['start_time_hour'] ?? 0,
                    starttimeminute: data['start_time_minute'] ?? 0,
                    temperature: data['temperature'] ?? 0,
                    startdouble: data['startdouble'] ?? 0.0,
                    enddouble: data['enddouble'] ?? 0.0,
                    id: data['id'] ?? 0,

    );
}
  
// String fancyDiscription(){
//   return 'lol $delete';
// }


}



