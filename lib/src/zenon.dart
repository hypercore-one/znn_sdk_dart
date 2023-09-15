import 'dart:async';

import 'package:znn_sdk_dart/src/api/api.dart' as api;
import 'package:znn_sdk_dart/src/client/client.dart';
import 'package:znn_sdk_dart/src/global.dart';
import 'package:znn_sdk_dart/src/model/model.dart';
import 'package:znn_sdk_dart/src/pow/pow.dart';
import 'package:znn_sdk_dart/src/utils/utils.dart';
import 'package:znn_sdk_dart/src/wallet/wallet.dart';

var noKeyPairSelectedException = ZnnSdkException('No default keyPair selected');

class Zenon {
  KeyPair? defaultKeyPair;

  late Client client;
  late api.LedgerApi ledger;
  late api.StatsApi stats;
  late api.EmbeddedApi embedded;
  late api.SubscribeApi subscribe;

  Zenon(Client client) {
    this.client = client;
    this.ledger = api.LedgerApi();
    this.stats = api.StatsApi();
    this.embedded = api.EmbeddedApi();
    this.subscribe = api.SubscribeApi();

    this.ledger.setClient(client);
    this.stats.setClient(client);
    this.embedded.setClient(client);
    this.subscribe.setClient(client);
  }

  Future<AccountBlockTemplate> send(AccountBlockTemplate transaction,
      {KeyPair? currentKeyPair,
      void Function(PowStatus)? generatingPowCallback,
      waitForRequiredPlasma = false}) async {
    currentKeyPair ??= defaultKeyPair;
    if (currentKeyPair == null) throw noKeyPairSelectedException;
    return BlockUtils.send(this, transaction, currentKeyPair,
        generatingPowCallback: generatingPowCallback,
        waitForRequiredPlasma: waitForRequiredPlasma);
  }

  Future<bool> requiresPoW(AccountBlockTemplate transaction,
      {KeyPair? blockSigningKey}) async {
    blockSigningKey ??= defaultKeyPair;
    return BlockUtils.requiresPoW(this, transaction, blockSigningKey: blockSigningKey);
  }
}
