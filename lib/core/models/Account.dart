import 'package:stellar_pocket_lab/core/database/AccountDatabase.dart';

class Account {
  int id;
  String username;
  String password;
  String publicKey;
  String privateKey;
  Account(
      this.id, this.username, this.password, this.publicKey, this.privateKey);

  Account.fromJson(Map<String, dynamic> json) {
    id = json[AccountDatabase.idNum];
    username = json[AccountDatabase.username];
    password = json[AccountDatabase.password];
    publicKey = json[AccountDatabase.publicKey];
    privateKey = json[AccountDatabase.privateKey];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data[AccountDatabase.idNum] = this.id;
    data[AccountDatabase.username] = this.username;
    data[AccountDatabase.password] = this.password;
    data[AccountDatabase.publicKey] = this.publicKey;
    data[AccountDatabase.privateKey] = this.privateKey;
    return data;
  }
}
