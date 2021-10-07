import 'package:flutter/material.dart';

class AccountCard extends StatelessWidget {
  final String name;
  final String publicKey;
  AccountCard({this.name, this.publicKey});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: ListTile(
        onTap: () {},
        leading: FlutterLogo(size: 56.0),
        title: Text(this.name),
        subtitle: Text(this.publicKey),
        trailing: Icon(Icons.more_vert),
      ),
    );
  }
}
