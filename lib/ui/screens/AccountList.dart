import 'package:flutter/material.dart';
import 'package:stellar_pocket_lab/core/services/AccountService.dart';
import 'package:stellar_pocket_lab/core/services/StellarService.dart';
import 'package:stellar_pocket_lab/locator.dart';

class AccountList extends StatefulWidget {
  @override
  _AccountListState createState() => _AccountListState();
}

class _AccountListState extends State<AccountList> {
  AccountService _accountService = locator<AccountService>();
  StellarService _stellarService = locator<StellarService>();
  @override
  void initState() {
    print(_accountService.tableName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
