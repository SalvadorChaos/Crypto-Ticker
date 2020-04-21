import 'dart:convert';

import 'package:http/http.dart' as http;

//List of Currencies
const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CHF',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'INR',
  'JPY',
  'MXN',
  'NZD',
  'PLN',
  'RON',
  'USD',
];

//List of Crypto Currencies
const List<String> cryptoList = [
  'BTC',
  'BSV',
  'ETH',
  'LTC',
  'MSC',
  'XRP',
];

//Get Coin Data
const cryptoCompareURL = 'https://min-api.cryptocompare.com';
const apiKey =
    '2980a098343698bd3bb90af8a3a27aaeab0555c4011c2f4a96daf904a96da1cf';

class CoinData {
  Future getCoinData(String selectedCurrency) async {
    //Loop through the cryptoList and request data for each in turn.
    //Return a Map of the results instead of a single value.
    Map<String, String> cryptoPrices = {};
    for (String cryptoCurrency in cryptoList) {
      String requestURL =
          '$cryptoCompareURL/data/price?fsym=$cryptoCurrency&tsyms=$selectedCurrency&api_key={$apiKey}';
      http.Response response = await http.get(requestURL);
      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        double lastPrice = decodedData['$selectedCurrency'];
        cryptoPrices[cryptoCurrency] = lastPrice.toStringAsFixed(0);
      } else {
        print(response.statusCode);
        throw 'There was problem with the get request.';
      }
    }
    return cryptoPrices;
  }
}
