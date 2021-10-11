import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:stellar_flutter_sdk/stellar_flutter_sdk.dart' as Stellar;
import 'package:stellar_pocket_lab/core/custom_exception/ExceptionWithMessage.dart';
import 'package:stellar_pocket_lab/core/database/AccountDatabase.dart';
import 'package:stellar_pocket_lab/core/models/Account.dart';
import 'package:stellar_pocket_lab/core/services/StellarService.dart';
import 'package:stellar_pocket_lab/locator.dart';

class AccountService {
  String _tableName;
  Account loggedInAccount;
  StellarService _stellarService = locator<StellarService>();

  String get tableName {
    return this._tableName;
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
    Stellar.KeyPair keyPair = _stellarService.generateNewKeyPair();
    String passwordHash = this.sha1Digest(password);
    String seed = this.md5Digest(password);
    String encryptedPrivateKey = this.aesEncrypt(seed, keyPair.secretSeed);
    await AccountDatabase.instance.insert({
      AccountDatabase.username: username,
      AccountDatabase.password: passwordHash,
      AccountDatabase.publicKey: keyPair.accountId,
      AccountDatabase.privateKey: encryptedPrivateKey
    }, this._tableName);
  }

  Future<List<Account>> load() async {
    var accounts = <Account>[];
    List<Map<String, dynamic>> rawData =
        await AccountDatabase.instance.read(this._tableName);
    for (var account in rawData) {
      accounts.add(Account.fromJson(account));
    }
    return accounts;
  }

  Future<void> login(Account account, String password) async {
    String passwordHash = this.sha1Digest(password);
    if (passwordHash == account.password) {
      String seed = this.md5Digest(password);
      try {
        String decryptPrivateKey = this.aesDecrypt(seed, account.privateKey);
        this.loggedInAccount = account;
        _stellarService.privateKey = decryptPrivateKey;
      } catch (e) {
        throw ExceptionWithMessage(message: "Unable to decrypt private key.");
      }
    } else {
      throw ExceptionWithMessage(message: "Incorrect Password.");
    }
  }

  Future<bool> checkAccount(String privateKey) async {
    String publicKey = _stellarService.publicKeyFromPrivateKey(privateKey);
    try {
      await _stellarService.loadAccountData(publicKey);
      return true;
    } catch (e) {
      return false;
    }
  }
}
