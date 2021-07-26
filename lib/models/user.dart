class CUser {
  String email;
  String id;
  CUser({this.id,this.email});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
    };
  }
}