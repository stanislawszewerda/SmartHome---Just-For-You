// mozna chyba usunac



class GetDeletedId {
  
  final bool delete;
  final int id;

  GetDeletedId({required this.delete, required this.id});
  
factory GetDeletedId.fromRTDB(Map<String, dynamic> data){
  return GetDeletedId(
    delete: data['delete'] ?? false,
    id: data['id'] ?? 0,
    );
}
  
String fancyDiscription(){
  return 'lol $delete';
}


}
