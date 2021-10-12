import 'package:stellar_flutter_sdk/stellar_flutter_sdk.dart';
import 'package:stellar_pocket_lab/core/custom_exception/ExceptionWithMessage.dart';

class StellarService {
  StellarSDK _sdk;
  Network _net;
  // String _publicKey;
  String _privateKey;

  StellarSDK get sdk => _sdk;
  Network get net => _net;
  // String get publicKey => _publicKey;
  //
  // set publicKey(String key) {
  //   this._publicKey = key;
  // }

  set privateKey(String key) {
    this._privateKey = key;
  }

  void mainnet() {
    _sdk = StellarSDK.PUBLIC;
    _net = Network.PUBLIC;
  }

  void testnet() {
    _sdk = StellarSDK.TESTNET;
    _net = Network.TESTNET;
  }

  KeyPair generateNewKeyPair() {
    KeyPair keyPair = KeyPair.random();
    return keyPair;
  }

  String publicKeyFromPrivateKey(String privateKey) {
    try {
      KeyPair keyPair = KeyPair.fromSecretSeed(privateKey);
      return keyPair.accountId;
    } catch (e) {
      throw ExceptionWithMessage(message: "Invalid private key.");
    }
  }

  Future<AccountResponse> loadAccountData(String publicKey) async {
    return await _sdk.accounts.account(publicKey);
  }
}
