
class UserModel{
  String? name;
  String? email;
  String? image;
  String? uid;

  UserModel({
    this.name,
    this.email,
    required this.uid,
    this.image
});

  UserModel.fromjson(Map<String, dynamic>?json){
    name=json?['name'];
    email=json?['email'];
    uid=json?['uid'];
    image=json?['image'];
  }

Map<String,dynamic>? toMap(){
    return{
      'name': name,
      'email': email,
      'uid': uid,
      'image': image,
    };
}
}