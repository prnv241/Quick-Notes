class Operation {
  String title;
  String body;
  String id;
  String noteid;
  String operation;
  String userid;
  Operation({this.id,this.title, this.body, this.noteid, this.operation, this.userid});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'userid': userid,
      'noteid': noteid,
      'operation': operation
    };
  }
}