import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:stellar_pocket_lab/core/custom_exception/ExceptionWithMessage.dart';
import 'package:stellar_pocket_lab/core/models/Account.dart';
import 'package:stellar_pocket_lab/core/services/AccountService.dart';
import 'package:stellar_pocket_lab/locator.dart';
import 'package:stellar_pocket_lab/ui/shared/colors.dart';
import 'package:stellar_pocket_lab/ui/shared/functions.dart';
import 'package:stellar_pocket_lab/ui/shared/ui_helpers.dart';

class AccountCard extends StatefulWidget {
  final Account account;

  AccountCard({this.account});

  @override
  _AccountCardState createState() => _AccountCardState();
}

class _AccountCardState extends State<AccountCard> {
  AccountService _accountService = locator<AccountService>();
  final loginKey = GlobalKey<FormState>();
  TextEditingController passwordController;

  @override
  void initState() {
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: ListTile(
        onTap: () {
          showModalBottomSheet(
            isScrollControlled: true,
            useRootNavigator: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            context: context,
            builder: (context) {
              return SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.82,
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  child: Form(
                    key: loginKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Text(
                            widget.account.username,
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: QrImage(
                            data: widget.account.publicKey,
                            size: 200,
                            backgroundColor: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          decoration: BoxDecoration(
                            color: purple,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: Text(
                                    widget.account.publicKey,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.copy_rounded,
                                    color: backgroundColor,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    FlutterClipboard.copy(
                                            widget.account.publicKey)
                                        .then(
                                      (value) {
                                        showToast("Copied!");
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
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
                            }
                            return null;
                          },
                          decoration: UIHelper.roundedInputDecoration(
                              hintText: "Password"),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          child: Text("Login"),
                          style: ElevatedButton.styleFrom(
                            primary: purple,
                            minimumSize: Size(0, 40),
                          ),
                          onPressed: () async {
                            if (loginKey.currentState.validate()) {
                              try {
                                await _accountService.login(
                                    widget.account, passwordController.text);
                                // Navigator.of(context).pop();
                              } on ExceptionWithMessage catch (e) {
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(
                                      e.message,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                );
                              } catch (e, s) {
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(
                                      "Something went wrong.",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                );
                                print(e);
                                print(s);
                              } finally {
                                passwordController.text = "";
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
                ),
              );
            },
          );
        },
        leading: QrImage(
          data: widget.account.publicKey,
          size: 56,
          backgroundColor: Colors.white,
        ),
        title: Text(widget.account.username),
        subtitle: Text(truncateMiddle(widget.account.publicKey, 4)),
        // trailing: Icon(Icons.more_vert),
        trailing: Icon(Icons.arrow_forward_ios_rounded),
      ),
    );
  }
}
