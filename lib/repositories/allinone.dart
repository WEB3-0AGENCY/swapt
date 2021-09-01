import 'dart:convert';

import 'package:yakuswap/models/currency.dart';

import 'package:http/http.dart' as http;
import 'package:yakuswap/models/eth_trade.dart';
import 'package:yakuswap/models/full_node_connection.dart';
import 'package:yakuswap/models/trade.dart';
import 'package:yakuswap/models/trade_status.dart';

// todo: error handling
// todo: api host offline

class AllInOneRepository {
  static const String API_HOST = "http://127.0.0.1:4143/api";

  Future<List<Currency>> getCurrencies() async {
    List<Currency> ret = [];

    final http.Response res = await http.get(Uri.parse("$API_HOST/currencies"));
    final Map<String, dynamic> parsed = jsonDecode(res.body);
    final List<Map<String, dynamic>> currencies = List<Map<String, dynamic>>.from(parsed['currencies']);

    for(int i = 0; i < currencies.length; ++i)
      ret.add(Currency.fromJSON(currencies[i]));

    return ret;
  }

  Future<List<Trade>> getTrades() async {
    List<Trade> ret = [];

    final http.Response res = await http.get(Uri.parse("$API_HOST/trades"));
    final Map<String, dynamic> parsed = jsonDecode(res.body);
    final List<Map<String, dynamic>> trades = List<Map<String, dynamic>>.from(parsed['trades']);

    for(int i = 0; i < trades.length; ++i)
      ret.add(Trade.fromJSON(trades[i]));

    return ret;
  }

  Future<List<FullNodeConnection>> getConnections() async {
    List<FullNodeConnection> ret = [];

    final http.Response res = await http.get(Uri.parse("$API_HOST/connection-status"));
    final Map<String, dynamic> parsed = jsonDecode(res.body);
    final List<Map<String, dynamic>> connections = List<Map<String, dynamic>>.from(parsed['connections']);

    for(int i = 0; i < connections.length; ++i)
      ret.add(FullNodeConnection.fromJSON(connections[i]));

    return ret;
  }

  Future<void> putCurrency({required Currency currency}) async {
    await http.put(
      Uri.parse("$API_HOST/currency/${currency.addressPrefix}"),
      body: jsonEncode(currency.toJSON()..remove("address_prefix")),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }

  Future<void> deleteCurrency({required String addressPrefix}) async {
    await http.delete(Uri.parse("$API_HOST/currency/$addressPrefix"));
  }

  Future<TradeStatus> getTrade({required String tradeId}) async {
    try {
      final http.Response resp = await http.get(Uri.parse("$API_HOST/trade/$tradeId"));
      return TradeStatus.fromJSON(jsonDecode(resp.body));
    } catch(_) {
      return TradeStatus(
        address: null,
        message: "Error while fetchng status. Retrying in 1s..."
      );
    }
  }

  Future<void> putTrade({required Trade trade}) async {
    await http.put(
      Uri.parse("$API_HOST/trade/${trade.id}"),
      body: jsonEncode(trade.toJSON()..remove("id")),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }

  Future<void> deleteTrade({required String id}) async {
    await http.delete(Uri.parse("$API_HOST/trade/$id"));
  }

  Future<void> putAddress({required String address}) async {
    await http.put(
      Uri.parse("$API_HOST/eth/address"),
      body: jsonEncode({"address": address}),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }

  Future<List<EthTrade>> getEthTrades() async {
    List<EthTrade> ret = [];

    final http.Response res = await http.get(Uri.parse("$API_HOST/eth/trades"));
    final Map<String, dynamic> parsed = jsonDecode(res.body);
    final List<Map<String, dynamic>> trades = List<Map<String, dynamic>>.from(parsed['trades']);

    for(int i = 0; i < trades.length; ++i)
      ret.add(EthTrade.fromJSON(trades[i]));

    return ret;
  }
}
