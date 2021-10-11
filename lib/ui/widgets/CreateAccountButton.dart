import 'package:flutter/material.dart';
import 'package:stellar_pocket_lab/core/services/AccountService.dart';
import 'package:stellar_pocket_lab/locator.dart';
import 'package:stellar_pocket_lab/ui/shared/colors.dart';
import 'package:stellar_pocket_lab/ui/shared/ui_helpers.dart';

class CreateAccountButton extends StatefulWidget {
  final Function refreshData;
  CreateAccountButton({this.refreshData});
  @override
  _CreateAccountButtonState createState() => _CreateAccountButtonState();
}

class _CreateAccountButtonState extends State<CreateAccountButton> {
  AccountService _accountService = locator<AccountService>();
  final createAccountKey = GlobalKey<FormState>();
  TextEditingController usernameController;
  TextEditingController passwordController;
  TextEditingController confirmPasswordController;

  @override
  void initState() {
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
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
                  key: createAccountKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Text(
                          "Create Account",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 20,
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
                        child: Text("Create"),
                        style: ElevatedButton.styleFrom(
                          primary: purple,
                          minimumSize: Size(0, 40),
                        ),
                        onPressed: () async {
                          if (createAccountKey.currentState.validate()) {
                            try {
                              await _accountService.create(
                                  usernameController.text,
                                  passwordController.text);
                              widget.refreshData();
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.green,
                                  content: Text(
                                    'Account Create Successful!',
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
              ),
            );
          },
        );
      },
      style: ElevatedButton.styleFrom(
        primary: purple,
        minimumSize: Size(0, 40),
      ),
      child: Text("Create Account"),
    );
  }
}
