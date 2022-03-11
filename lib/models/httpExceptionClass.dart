class HttpExceptions implements Exception{
final String message;

  HttpExceptions(this.message);

  String toString(){
    return message;
  }
}

