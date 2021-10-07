import 'package:flutter/material.dart';
import 'package:stellar_pocket_lab/core/services/AccountService.dart';
import 'package:stellar_pocket_lab/ui/shared/colors.dart';
import 'package:stellar_pocket_lab/ui/shared/ui_helpers.dart';

class CreateAccountButton extends StatelessWidget {
  final createAccountKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final AccountService accountService;
  CreateAccountButton({this.accountService});

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
                height: MediaQuery.of(context).size.height * 0.4,
                width: double.infinity,
                padding: EdgeInsets.all(20),
                child: Form(
                  key: createAccountKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: usernameController,
                        cursorColor: Colors.black,
                        validator: (input) {
                          if (input.isEmpty) {
                            return "Please enter username.";
                          }
                          return null;
                        },
                        decoration:
                            roundedInputDecoration(hintText: "Username"),
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
                          } else if (input.length <= 4) {
                            return "Minimum password length is 4.";
                          }
                          return null;
                        },
                        decoration:
                            roundedInputDecoration(hintText: "Password"),
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
                          } else if (input == passwordController.text) {
                            return "Password doesn't match.";
                          }
                          return null;
                        },
                        decoration: roundedInputDecoration(
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
                              await accountService.create(
                                  usernameController.text,
                                  passwordController.text);
                              Navigator.of(context).pop();
                            } catch (e, s) {
                              print(e);
                              print(s);
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
