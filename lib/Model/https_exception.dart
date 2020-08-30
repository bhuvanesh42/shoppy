class HttpsException implements Exception{
  final String messsge;
   HttpsException(this.messsge);
   @override
  String toString() {
    // TODO: implement toString
     return messsge;
    /*return super.toString();*/
  }
}