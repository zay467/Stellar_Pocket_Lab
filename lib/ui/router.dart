import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stellar_pocket_lab/ui/screens/AccountList.dart';
import 'package:stellar_pocket_lab/ui/screens/Network.dart';
import 'package:stellar_pocket_lab/ui/shared/routeName.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    dynamic args = settings.arguments;
    switch (settings.name) {
      case RouteName.network:
        return MaterialPageRoute(builder: (_) => Network());
      case RouteName.accountList:
        return MaterialPageRoute(builder: (_) => AccountList());
    }
  }
}
