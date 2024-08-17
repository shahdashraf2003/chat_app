class Message {
  final String message;
  final String id;
  

  Message(this.message,  this.id);

  factory Message.fromJson( json) {
    return Message(

      json['messages'],
      json['id'],
    );
  }
}
