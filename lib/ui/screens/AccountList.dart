import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stellar_pocket_lab/core/models/Account.dart';
import 'package:stellar_pocket_lab/core/services/AccountService.dart';
import 'package:stellar_pocket_lab/locator.dart';
import 'package:stellar_pocket_lab/ui/shared/colors.dart';
import 'package:stellar_pocket_lab/ui/shared/ui_helpers.dart';
import 'package:stellar_pocket_lab/ui/widgets/AccountCard.dart';
import 'package:stellar_pocket_lab/ui/widgets/CreateAccountButton.dart';

class AccountList extends StatefulWidget {
  @override
  _AccountListState createState() => _AccountListState();
}

class _AccountListState extends State<AccountList>
    with TickerProviderStateMixin {
  TabController tabController;
  AccountService _accountService = locator<AccountService>();
  List<Account> accounts = [];
  final importAccountKey = GlobalKey<FormState>();
  TextEditingController privateKeyController;
  TextEditingController usernameController;
  TextEditingController passwordController;
  TextEditingController confirmPasswordController;

  void getAllAccounts() async {
    List<Account> data = await _accountService.load();
    setState(() {
      accounts = data;
    });
  }

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    privateKeyController = TextEditingController();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    getAllAccounts();
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    privateKeyController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
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
                  itemCount: accounts.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return CreateAccountButton(
                        refreshData: getAllAccounts,
                      );
                    }
                    return AccountCard(
                      account: accounts[index - 1],
                    );
                  },
                ),
                Form(
                  key: importAccountKey,
                  child: ListView(
                    padding: EdgeInsets.all(20),
                    children: [
                      TextFormField(
                        controller: privateKeyController,
                        cursorColor: Colors.black,
                        obscureText: true,
                        validator: (input) {
                          if (input.isEmpty) {
                            return "Please enter private key.";
                          }
                          return null;
                        },
                        decoration: UIHelper.roundedInputDecoration(
                            hintText: "Private Key"),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: usernameController,
                        cursorColor: Colors.black,
                        validator: (input) {
                          if (input.isEmpty) {
                            return "Please enter username.";
                          } else if (input.length > 20) {
                            return "Username is too long.";
                          }
                          return null;
                        },
                        decoration: UIHelper.roundedInputDecoration(
                            hintText: "Username"),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: passwordController,
                        cursorColor: Colors.black,
                        obscureText: true,
                        validator: (input) {
                          if (input.isEmpty) {
                            return "Please enter password";
                          } else if (input.length < 6) {
                            return "Minimum password length is 6.";
                          }
                          return null;
                        },
                        decoration: UIHelper.roundedInputDecoration(
                            hintText: "Password"),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: confirmPasswordController,
                        keyboardType: TextInputType.emailAddress,
                        cursorColor: Colors.black,
                        obscureText: true,
                        validator: (input) {
                          if (input.isEmpty) {
                            return "Please confirm password.";
                          } else if (input != passwordController.text) {
                            return "Password doesn't match.";
                          }
                          return null;
                        },
                        decoration: UIHelper.roundedInputDecoration(
                            hintText: "Confirm Password"),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      ElevatedButton(
                        child: Text("Import"),
                        style: ElevatedButton.styleFrom(
                          primary: purple,
                          minimumSize: Size(0, 40),
                        ),
                        onPressed: () async {
                          if (importAccountKey.currentState.validate()) {
                            try {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.green,
                                  content: Text(
                                    'Account Create Successful!',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              );
                              Navigator.of(context).pop();
                            } catch (e, s) {
                              print(e);
                              print(s);
                            } finally {
                              usernameController.text = "";
                              passwordController.text = "";
                              confirmPasswordController.text = "";
                            }
                          }
                        },
                      ),
                      Text(
                        "Your username, password and wallet's keys will be stored locally. And there is no way of recovering your account.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 10),
                        overflow: TextOverflow.visible,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
