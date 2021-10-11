import 'package:get_it/get_it.dart';
import 'package:stellar_pocket_lab/core/services/AccountService.dart';
import 'package:stellar_pocket_lab/core/services/StellarService.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  // Services
  locator.registerLazySingleton(() => AccountService());
  locator.registerLazySingleton(() => StellarService());
}
