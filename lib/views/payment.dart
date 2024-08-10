import 'package:capstone/views/main_page.dart';
import 'package:flutter/material.dart';
import 'package:pay_with_paystack/pay_with_paystack.dart';

class Payment extends StatefulWidget {
  const Payment({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () {
                  final uniqueTransRef = PayWithPayStack().generateUuidV4();

                  PayWithPayStack().now(
                      context: context,
                      secretKey:
                          "",
                      customerEmail: "bernd.opoku.boadu@gmail.com",
                      reference: uniqueTransRef,
                      currency: "GHS",
                      amount: 200,
                      transactionCompleted: () {
                        print("Transaction Successful");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const UserMainPage()),
                        );
                      },
                      transactionNotCompleted: () {
                        print("Transaction Not Successful!");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const Payment(title: 'title')),
                        );
                      },
                      callbackUrl: '');
                },
                child: const Text(
                  "Pay With PayStack",
                  style: TextStyle(fontSize: 23),
                ))
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
