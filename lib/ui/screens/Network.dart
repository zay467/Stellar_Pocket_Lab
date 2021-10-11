import 'package:flutter/material.dart';
import 'package:stellar_pocket_lab/core/database/AccountDatabase.dart';
import 'package:stellar_pocket_lab/core/services/AccountService.dart';
import 'package:stellar_pocket_lab/core/services/StellarService.dart';
import 'package:stellar_pocket_lab/locator.dart';
import 'package:stellar_pocket_lab/ui/shared/colors.dart';
import 'package:stellar_pocket_lab/ui/shared/routeName.dart';

class Network extends StatelessWidget {
  AccountService _accountService = locator<AccountService>();
  StellarService _stellarService = locator<StellarService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.98,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/stellar-logo.png"),
                          fit: BoxFit.contain),
                    ),
                  ),
                  Text(
                    "Stellar Pocket Lab",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _accountService.tableName =
                              AccountDatabase.mainnetTable;

                          Navigator.pushNamed(context, RouteName.accountList);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: purple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50),
                              bottomLeft: Radius.circular(50),
                            ),
                          ),
                        ),
                        child: Text("MAINNET"),
                      ),
                      SizedBox(
                        width: 0,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _accountService.tableName =
                              AccountDatabase.testnetTable;
                          _stellarService.testnet();
                          Navigator.pushNamed(context, RouteName.accountList);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(50),
                              bottomRight: Radius.circular(50),
                            ),
                          ),
                        ),
                        child: Text("TESTNET"),
                      ),
                    ],
                  ),
                  Text(
                    "TESTNET is for testing purposes and doesn't have real values.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ),
            Text(
              "Developed by Zay Maw",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
