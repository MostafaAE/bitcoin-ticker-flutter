import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'coin_data.dart';
import 'crypto_card.dart';
import 'dart:io' show Platform;
import 'constants.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {

  String selectedCurrency = currenciesList.first;
  Map<String, String> cryptoPrices = new Map();
  bool isWaiting = false;

  DropdownButton<String> androidDropDown()
  {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for(String currency in currenciesList)
    {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      dropdownColor: dropDownColor,
      icon: Icon(Icons.keyboard_arrow_up),
      style: TextStyle(fontSize: 18.0),
      iconSize: 32,
      underline: Container(
        height: 2,
        color: Colors.white,
      ),
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) {
       setState(() {
        selectedCurrency = value;
        getData();
        });
      },
    );
  }

  CupertinoPicker iOSPicker()
  {
    List<Text> pickerItems = [];
    for(String currency in currenciesList)
      pickerItems.add(Text(currency,style: TextStyle(color: Colors.white,),),);

    return CupertinoPicker(
      backgroundColor: primaryColor,
      onSelectedItemChanged: (selectedIndex){
        setState(() {
        selectedCurrency = currenciesList[selectedIndex];
        getData();
        });
      },
      itemExtent: 32,
      children: pickerItems,
    );
  }

  void getData() async
  {
    try {
      isWaiting = true;
      Map<String, String> data = await CoinData().getCoinData(selectedCurrency);
      isWaiting = false;
      setState(() {
        cryptoPrices = data;
      });
    }
    catch (e) {
      print(e);
    }
  }

  Column getCryptoCards()
  {
    List<CryptoCard> cryptoCards = [];
    for(String crypto in cryptoList)
    {
      cryptoCards.add(CryptoCard(
        cryptoCurrency: crypto,
        exchangeRate: isWaiting ? '?' : cryptoPrices[crypto],
        selectedCurrency: selectedCurrency,
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: cryptoCards,
    );
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crypto Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          getCryptoCards(),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 15.0, top: 15),
            color: primaryColor,
            child: Platform.isIOS ? iOSPicker() : androidDropDown(),
          ),
        ],
      ),
    );
  }
}
