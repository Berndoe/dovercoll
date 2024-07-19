import 'package:flutter/material.dart';

class HistoryCards extends StatelessWidget {
  final int amount;
  final DateTime time;
  final String paymentMethod;

  const HistoryCards(
      {super.key,
      required this.amount,
      required this.time,
      required this.paymentMethod});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'name',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'phoneNumber',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.remove_red_eye_sharp, color: Colors.blue),
            onPressed: () async {},
          ),
        ],
      ),
    );
  }
}
