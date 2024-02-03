class AccountModel {
  String? acc_Email;
  String? acc_password;
  String? acc_rank;
  String? uid;
  String? name;
  String? image;
  bool? acc_state;

  AccountModel(
      {this.acc_Email, this.acc_password, this.acc_rank, this.name, this.uid,this.image,this.acc_state});

  AccountModel.fromjson(Map<String, dynamic>? json) {
    acc_Email = json?['acc_Email'];
    acc_password = json?['acc_password'];
    acc_rank = json?['acc_rank'];
    name = json?['name'];
    uid = json?['uid'];
    image = json?['image'];
    acc_state = json?['acc_state'];
  }

  Map<String, dynamic>? toMap() {
    return {
      'acc_Email': acc_Email,
      'acc_password': acc_password,
      'acc_rank': acc_rank,
      'name': name,
      'uid': uid,
      'image': image,
      'acc_state': acc_state,
    };
  }
}
