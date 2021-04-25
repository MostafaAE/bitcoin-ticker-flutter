import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;
class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {

  String selectedCurrency = 'AUD';
  int exRate;

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
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) {
       setState(() {
        selectedCurrency = value;
        getData('BTC', selectedCurrency);
        });
      },
    );
  }

  CupertinoPicker iOSPicker()
  {
    List<Text> pickerItems = [];
    for(String currency in currenciesList)
      pickerItems.add(Text(currency));

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      onSelectedItemChanged: (selectedIndex){
        selectedCurrency = currenciesList[selectedIndex];
        getData('BTC', selectedCurrency);
      },
      itemExtent: 32,
      children: pickerItems,
    );
  }

  void getData(String base, String quote) async
  {
    try {
      var coinExRate = await CoinData().getCoinData(base, quote);
      setState(() {
        exRate = coinExRate['rate'].toInt();
      });
    }
    catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getData('BTC', selectedCurrency);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 BTC = $exRate $selectedCurrency',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropDown(),
          ),
        ],
      ),
    );
  }
}
