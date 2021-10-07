import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stellar_pocket_lab/core/services/AccountService.dart';
import 'package:stellar_pocket_lab/core/services/StellarService.dart';
import 'package:stellar_pocket_lab/locator.dart';
import 'package:stellar_pocket_lab/ui/shared/mock_data.dart';
import 'package:stellar_pocket_lab/ui/widgets/AccountCard.dart';
import 'package:stellar_pocket_lab/ui/widgets/CreateAccountButton.dart';

class AccountList extends StatefulWidget {
  @override
  _AccountListState createState() => _AccountListState();
}

class _AccountListState extends State<AccountList>
    with TickerProviderStateMixin {
  AccountService _accountService = locator<AccountService>();
  StellarService _stellarService = locator<StellarService>();

  TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    print(_accountService.tableName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Text(
                _accountService.tableName.toUpperCase(),
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          TabBar(
            indicatorColor: Colors.black,
            controller: tabController,
            indicatorWeight: 2,
            tabs: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  "Accounts",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  "Import",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.83,
            child: TabBarView(
              controller: tabController,
              children: [
                ListView.builder(
                  padding: EdgeInsets.all(20),
                  itemCount: mock_account.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return CreateAccountButton(
                        accountService: _accountService,
                      );
                    }
                    return AccountCard(
                      name: mock_account[index - 1]["name"],
                      publicKey: mock_account[index - 1]["publicKey"],
                    );
                  },
                ),
                ListView(
                  padding: EdgeInsets.all(20),
                  children: [Text("Hi")],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
