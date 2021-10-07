import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:stellar_flutter_sdk/stellar_flutter_sdk.dart';
import 'package:stellar_pocket_lab/core/database/AccountDatabase.dart';
import 'package:stellar_pocket_lab/core/services/StellarService.dart';
import 'package:stellar_pocket_lab/locator.dart';

class AccountService {
  String _tableName;
  StellarService _stellarService = locator<StellarService>();

  String get tableName {
    return _tableName;
  }

  set tableName(String name) {
    this._tableName = name;
  }

  String sha1Digest(String text) {
    var bytes = utf8.encode(text);
    Digest digest = sha1.convert(bytes);
    return digest.toString();
  }

  String md5Digest(String text) {
    var bytes = utf8.encode(text);
    Digest digest = md5.convert(bytes);
    return digest.toString();
  }

  String aesEncrypt(String seed, String text) {
    Key key = Key.fromUtf8(seed);
    IV iv = IV.fromLength(16);
    Encrypter encrypter = Encrypter(AES(key));
    Encrypted encrypted = encrypter.encrypt(text, iv: iv);
    return encrypted.base64;
  }

  String aesDecrypt(String seed, String encryptedText) {
    Key key = Key.fromUtf8(seed);
    IV iv = IV.fromLength(16);
    Encrypter encrypter = Encrypter(AES(key));
    Encrypted encrypted = Encrypted.fromBase64(encryptedText);
    String decrypted = encrypter.decrypt(encrypted, iv: iv);
    return decrypted;
  }

  Future<void> create(String username, String password) async {
    KeyPair keyPair = _stellarService.generateNewKeyPair();
    String passwordHash = sha1Digest(password);
    String seed = md5Digest(password);
    String encryptedPrivateKey = aesEncrypt(seed, keyPair.secretSeed);
    await AccountDatabase.instance.insert({
      AccountDatabase.username: username,
      AccountDatabase.password: passwordHash,
      AccountDatabase.publicKey: keyPair.accountId,
      AccountDatabase.privateKey: encryptedPrivateKey
    }, _tableName);
  }
}
