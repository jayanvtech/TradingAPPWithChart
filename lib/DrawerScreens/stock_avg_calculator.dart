import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StockAverageCalculator extends StatefulWidget {
  @override
  _StockAverageCalculatorState createState() => _StockAverageCalculatorState();
}

class _StockAverageCalculatorState extends State<StockAverageCalculator> {
  List<Map<String, dynamic>> stockPurchases = [
    {'price': 0.0, 'quantity': 0},
  ];

  double totalShares = 0;
  double totalAmount = 0;
  double averagePrice = 0;

  // Function to calculate totals and average price
  void calculateAverage() {
    double shares = 0;
    double amount = 0;

    for (var stock in stockPurchases) {
      shares += stock['quantity'];
      amount += stock['price'] * stock['quantity'];
    }

    setState(() {
      totalShares = shares;
      totalAmount = amount;
      averagePrice = shares > 0 ? amount / shares : 0;
    });
  }

  // Add a new purchase entry
  void addPurchase() {
    setState(() {
      stockPurchases.add({'price': 0.0, 'quantity': 0});
    });
  }

  // Widget for each purchase input
  Widget stockPurchaseInput(int index) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'Buy Price',
              prefixText: '₹ ',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                stockPurchases[index]['price'] = double.tryParse(value) ?? 0.0;
                calculateAverage();
              });
            },
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'Quantity',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                stockPurchases[index]['quantity'] = int.tryParse(value) ?? 0;
                calculateAverage();
              });
            },
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Stock Average Calculator"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              ...List.generate(
                stockPurchases.length,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: stockPurchaseInput(index),
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5))),
                onPressed: addPurchase,
                icon: Icon(Icons.add),
                label: Text("Add More"),
              ),
              Divider(height: 40),
              Text(
                "Total Shares: ${totalShares.toStringAsFixed(0)}",
                style: TextStyle(fontSize: 18),
              ),
              Text(
                "Total Amount: ₹${totalAmount.toStringAsFixed(2)}",
                style: TextStyle(fontSize: 18),
              ),
              Text(
                "Average Price: ₹${averagePrice.toStringAsFixed(2)}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
