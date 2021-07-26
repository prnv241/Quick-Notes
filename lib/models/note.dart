class Note {
  String title;
  String body;
  String id;
  String userid;
  Note({this.id,this.title, this.body, this.userid});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'userid': userid
    };
  }
}