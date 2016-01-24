/// DSA Broker Implementation
library dsbroker.broker;

import "dart:async";
import "dart:io";
import "dart:convert";

import "package:dslink/client.dart" show LinkProvider;
import "package:dslink/responder.dart";
import "package:dslink/requester.dart";
import "package:dslink/common.dart";
import "package:dslink/server.dart";
import "package:dslink/utils.dart";
import "package:dslink/src/http/websocket_conn.dart";
import "package:dslink/query.dart";
import "package:dslink/io.dart";
import "package:dslink/src/storage/simple_storage.dart";

part "src/broker/broker_node_provider.dart";
part "src/broker/broker_node.dart";
part "src/broker/remote_node.dart";
part "src/broker/remote_root_node.dart";
part "src/broker/remote_requester.dart";
part "src/broker/broker_permissions.dart";
part "src/broker/broker_alias.dart";
part "src/broker/user_node.dart";
part "src/broker/trace_node.dart";
part "src/broker/throughput.dart";
part "src/broker/data_nodes.dart";
part "src/broker/tokens.dart";
part "src/broker/responder.dart";

part "src/http/server_link.dart";
part "src/http/server.dart";

part "src/broker/query_node.dart";
part "src/broker/broker_profiles.dart";

Future<DsHttpServer> startBrokerServer(int port, {
  bool persist: true,
  BrokerNodeProvider broker,
  host,
  bool loadAllData: true
}) async {
  if (host == null) {
    host = InternetAddress.ANY_IP_V4;
  }
  if (broker == null) {
    broker = new BrokerNodeProvider(
      downstreamName: "downstream"
    );
  }
  broker.shouldSaveFiles = persist;
  var server = new DsHttpServer.start(
    host,
    httpPort: port,
    nodeProvider: broker,
    linkManager: broker
  );

  if (loadAllData) {
    await broker.loadAll();
  }

  await server.onServerReady;
  return server;
}
