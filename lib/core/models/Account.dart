import 'package:stellar_pocket_lab/core/database/AccountDatabase.dart';

class Account {
  int id;
  String name;
  String password;
  String publicKey;
  String privateKey;
  Account(this.id, this.name, this.password, this.publicKey, this.privateKey);

  Account.fromJson(Map<String, dynamic> json) {
    id = json[AccountDatabase.idNum];
    name = json[AccountDatabase.accName];
    password = json[AccountDatabase.password];
    publicKey = json[AccountDatabase.publicKey];
    privateKey = json[AccountDatabase.privateKey];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data[AccountDatabase.idNum] = this.id;
    data[AccountDatabase.accName] = this.name;
    data[AccountDatabase.password] = this.password;
    data[AccountDatabase.publicKey] = this.publicKey;
    data[AccountDatabase.privateKey] = this.privateKey;
    return data;
  }
}
