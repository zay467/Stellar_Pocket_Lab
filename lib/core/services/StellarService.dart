import 'package:stellar_flutter_sdk/stellar_flutter_sdk.dart';

class StellarService {
  StellarSDK _sdk;
  Network _net;

  StellarSDK get sdk {
    return _sdk;
  }

  set sdk(StellarSDK type) {
    this._sdk = type;
  }

  Network get net {
    return _net;
  }

  set net(Network type) {
    this._net = type;
  }

  KeyPair generateNewKeyPair() {
    KeyPair keyPair = KeyPair.random();
    return keyPair;
  }
}
