import 'dart:io';

import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';

  //Dropdown Menu for Android.
  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownMenuItems = [];
    for (String currency in currenciesList) {
      var newDropdownMenuItem = DropdownMenuItem(
        child: Text(
          currency,
          style: TextStyle(
            backgroundColor: Colors.yellow,
            color: Colors.black,
          ),
        ),
        value: currency,
      );
      dropdownMenuItems.add(newDropdownMenuItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownMenuItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          getData();
        });
      },
    );
  }

  //Cupertino Picker for iOS.
  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }

    int indexOfUSD = currenciesList.indexOf('USD');

    return CupertinoPicker(
      children: pickerItems,
      backgroundColor: Colors.black,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        print(currenciesList[selectedIndex]);
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
          getData();
        });
      },
      scrollController: FixedExtentScrollController(
        initialItem: indexOfUSD,
      ),
    );
  }

  //Coin value in the selected currency.
  String value = '?';

  Map<String, String> coinValues = {};
  //Display a '?' on screen while waiting for price data.
  bool isWaiting = false;

  //Get data.
  void getData() async {
    isWaiting = true;
    try {
      var data = await CoinData().getCoinData(selectedCurrency);
      isWaiting = false;
      setState(() {
        //OLD CODE
        //value = data.toStringAsFixed(0);
        //print(value);
        coinValues = data;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  //Loop through the cryptoList and generate a CryptoCard for each.
  Column getCryptoCards() {
    List<CryptoCard> cryptoCards = [];
    for (String cryptoCurrency in cryptoList) {
      cryptoCards.add(
        CryptoCard(
          cryptoCurrency: cryptoCurrency,
          value: isWaiting ? '?' : coinValues[cryptoCurrency],
          selectedCurrency: selectedCurrency,
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: cryptoCards,
    );
  }

  //Price Screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('🤑 Crypto Ticker'),
      ),
      backgroundColor: Colors.yellow,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          //Use a Column Widget to contain the CryptoCards.
          getCryptoCards(),
          Expanded(
            flex: 1,
            child: Container(
              height: 150.0,
              alignment: Alignment.center,
              padding: EdgeInsets.only(bottom: 30.0),
              color: Colors.black,
              child: Platform.isIOS ? iOSPicker() : androidDropdown(),
            ),
          ),
        ],
      ),
    );
  }
}

//Create a card for each cryptoCurrency.
class CryptoCard extends StatelessWidget {
  const CryptoCard({
    @required this.cryptoCurrency,
    @required this.value,
    @required this.selectedCurrency,
  });

  final String cryptoCurrency;
  final String value;
  final String selectedCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.black,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $cryptoCurrency = $value $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

//OLD CODE
//
//Column(
//crossAxisAlignment: CrossAxisAlignment.stretch,
//children: <Widget>[
//CryptoCard(
//cryptoCurrency: 'BTC',
//value: isWaiting ? '?' : value,
//selectedCurrency: selectedCurrency,
//),
//CryptoCard(
//cryptoCurrency: 'ETH',
//value: isWaiting ? '?' : value,
//selectedCurrency: selectedCurrency,
//),
//CryptoCard(
//cryptoCurrency: 'LTC',
//value: isWaiting ? '?' : value,
//selectedCurrency: selectedCurrency,
//),
//CryptoCard(
//cryptoCurrency: 'MSC',
//value: isWaiting ? '?' : value,
//selectedCurrency: selectedCurrency,
//),
//],
//)
//
