import 'dart:convert';

import 'package:http/http.dart' as http;

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

//This is a fake API Key
const apiKey = 'F8FDA4B8-6357-4147-AAEE-22C2DA5583B7';

const coinApiExRate = 'https://rest.coinapi.io/v1/exchangerate';

class CoinData {
  Future<Map<String, String>> getCoinData(String selectedCurrency) async {
    Map<String, String> cryptoPrices = Map();
    for (String crypto in cryptoList) {
      Uri url =
          Uri.parse('$coinApiExRate/$crypto/$selectedCurrency?apiKey=$apiKey');
      http.Response response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        cryptoPrices[crypto] = data['rate'].toStringAsFixed(0);
      } else {
        print(response.statusCode);
        throw 'Problem with the get request';
      }
    }
    return cryptoPrices;
  }
}
